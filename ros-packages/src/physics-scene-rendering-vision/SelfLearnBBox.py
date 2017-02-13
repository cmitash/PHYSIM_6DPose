'''
EnforePhysics.py
author: Chaitanya Mitash (cm1074@cs.rutgers.edu)
'''

import bpy
import bpy_extras
import sys
import os, tempfile, glob, shutil
import math
import random
import time
import socket
from mathutils import Vector
from mathutils import Matrix
from mathutils import Quaternion

# Verify if path is set in bashrc
if os.environ.get('PHYSIM_6DPose_PATH') == None:
    print("Please set PHYSIM_6DPose_PATH in bashrc!")
    sys.exit()

g_repo_path = os.environ['PHYSIM_6DPose_PATH']

# Different Light Settings
g_syn_light_environment_energy_lowbound = 0.5
g_syn_light_environment_energy_highbound = 1

# Camera Intrinsic matrix
# K = Matrix(([611.355347, 0.0, 337.405731],[0.0, 611.355408, 247.190155],[0.0, 0.0, 1.0 ]))
K = Matrix(([611.355347, 0.0, 320],[0.0, 611.355408, 240],[0.0, 0.0, 1.0 ]))


# Object Files (.obj)
object_file_list = ["crayola_24_ct", "expo_dry_erase_board_eraser", "folgers_classic_roast_coffee",
                    "scotch_duct_tape", "dasani_water_bottle", "jane_eyre_dvd",
                    "up_glucose_bottle", "laugh_out_loud_joke_book", "soft_white_lightbulb",
                    "kleenex_tissue_box", "ticonderoga_12_pencils", "dove_beauty_bar",
                    "dr_browns_bottle_brush", "elmers_washable_no_run_school_glue", "rawlings_baseball" ]

object_file_dict = {'crayola_24_ct':1, 'expo_dry_erase_board_eraser':2, 'folgers_classic_roast_coffee':3,
                    'scotch_duct_tape':4, 'dasani_water_bottle':5, 'jane_eyre_dvd':6,
                    'up_glucose_bottle':7, 'laugh_out_loud_joke_book':8, 'soft_white_lightbulb':9,
                    'kleenex_tissue_box':10, 'ticonderoga_12_pencils':11, 'dove_beauty_bar':12,
                    'dr_browns_bottle_brush':13, 'elmers_washable_no_run_school_glue':14, 'rawlings_baseball':15}

# Input Pose File path
init_pose_file = g_repo_path + '/tmp/init_pose.txt'
cam_pose_file = g_repo_path + '/tmp/cam_pose.txt'
# cam_pose_file = '/home/pracsys/github/database/cam_pose.txt';
############################################################################
##### CORRECT POSES ##################################################
############################################################################

# Input parameters
env = sys.argv[-2]
syn_images_folder = sys.argv[-1]
if not os.path.exists(syn_images_folder):
    os.mkdir(syn_images_folder)

scene = bpy.context.scene
objects = bpy.data.objects

# Creates a blender camera consistent with a given intrinsic matrix
def set_camera_using_intrinsics():
    scene = bpy.context.scene
    sensor_width_in_mm = K[1][1]*K[0][2] / (K[0][0]*K[1][2])
    sensor_height_in_mm = 1  # doesn't matter
    resolution_x_in_px = K[0][2]*2  # principal point assumed at the center
    resolution_y_in_px = K[1][2]*2  # principal point assumed at the center

    # resolution_x_in_px = 640
    # resolution_y_in_px = 480

    s_u = resolution_x_in_px / sensor_width_in_mm
    s_v = resolution_y_in_px / sensor_height_in_mm
    f_in_mm = K[0][0] / s_u

    # recover original resolution
    scene.render.resolution_x = resolution_x_in_px
    scene.render.resolution_y = resolution_y_in_px
    scene.render.resolution_percentage = 100

    # set camera parameters
    cam_ob = scene.objects['Camera']
    cam_ob.location = [0, 0, 0]
    cam_ob.rotation_mode = 'QUATERNION'
    cam_ob.rotation_quaternion = [1, 0, 0, 0]

    cam_ob.data.type = 'PERSP'
    cam_ob.data.lens = f_in_mm 
    cam_ob.data.lens_unit = 'MILLIMETERS'
    cam_ob.data.sensor_width  = sensor_width_in_mm

    scene.camera = cam_ob
    bpy.context.scene.update()

def get_3x4_RT_matrix_from_blender(cam):
    # bcam stands for blender camera
    R_bcam2cv = Matrix(
        ((1, 0,  0),
         (0, -1, 0),
         (0, 0, -1)))

    # Use matrix_world instead to account for all constraints
    location, rotation = cam.matrix_world.decompose()[0:2]
    R_world2bcam = rotation.to_matrix().transposed()

    # Convert camera location to translation vector used in coordinate changes
    # Use location from matrix_world to account for constraints:     
    T_world2bcam = -1*R_world2bcam * location

    # Build the coordinate transform matrix from world to computer vision camera
    R_world2cv = R_bcam2cv*R_world2bcam
    T_world2cv = R_bcam2cv*T_world2bcam

    # put into 3x4 matrix
    RT = Matrix((
        R_world2cv[0][:] + (T_world2cv[0],),
        R_world2cv[1][:] + (T_world2cv[1],),
        R_world2cv[2][:] + (T_world2cv[2],)
         ))
    return RT

# Return K*RT, K, and RT from the blender camera
def get_3x4_P_matrix_from_blender(cam):
    RT = get_3x4_RT_matrix_from_blender(cam)
    return K*RT, K, RT

# Compute the bounds of the object by iterating over all vertices
def camera_view_bounds_2d(me_ob):
    min_x, max_x = 10000, 0.0
    min_y, max_y = 10000, 0.0

    scene = bpy.context.scene
    cam_ob = scene.objects['Camera']

    print ("object location : ", me_ob.matrix_world.translation)

    coworld = [(me_ob.matrix_world * v.co) for v in me_ob.data.vertices]
    proj, K, RT = get_3x4_P_matrix_from_blender(cam_ob)

    for v in coworld:
        a = Vector((v.x, v.y, v.z, 1))
        coords = proj * a
        coords /= coords[2]

        if coords.x < min_x:
            min_x = coords.x
        if coords.x > max_x:
            max_x = coords.x
        if coords.y < min_y:
            min_y = coords.y
        if coords.y > max_y:
            max_y = coords.y

    print ("bbox : ", min_x, max_x, min_y, max_y)
    return (min_x, min_y, max_x - min_x, max_y - min_y)

def write_bounds_2d(filepath, me_ob):
    with open(filepath, "a+") as file:
        print("get bounding box of " + me_ob.name)
        print("3d location ", me_ob.matrix_world.translation)
        x, y, width, height = camera_view_bounds_2d(me_ob)
        if x > scene.render.resolution_x or \
           y > scene.render.resolution_y or \
           x + width < 0 or \
           y + height < 0 or \
           width < 0 or height < 0:
            print ("bbox out of range: (x, y, width, height), ignored!", x, y, width, height)
            return -1, -1, -1, -1
        else:
            # if bbox is out of camera range, crop it
            if x < 0:
                width = width + x
                x = 0
            if y < 0:
                height = height + y
                y = 0
            if x + width > scene.render.resolution_x:
                width = scene.render.resolution_x - x
            if y + height > scene.render.resolution_y:
                height = scene.render.resolution_y - y
            file.write(me_ob.name)
            file.write(",%i,%i,%i,%i,%f\n" % (x, y, width, height, me_ob.matrix_world.translation[0]))
            return x, y, width, height

# environment lighting
bpy.ops.object.select_by_type(type='LAMP')
bpy.ops.object.delete(use_global=False)
bpy.context.scene.world.light_settings.use_environment_light = True
bpy.context.scene.world.light_settings.environment_energy = random.uniform(g_syn_light_environment_energy_lowbound, 
                                                                                g_syn_light_environment_energy_highbound)
bpy.context.scene.world.light_settings.environment_color = 'PLAIN'

#add light source
bpy.ops.object.lamp_add(type='POINT', view_align = False, location=(0, 0, 0))
objects['Point'].data.use_specular = False
objects['Point'].data.shadow_method = 'RAY_SHADOW'
objects['Point'].data.shadow_ray_samples = 2
objects['Point'].data.shadow_soft_size = 0.5

# import objects to blender
objectlist = []
for obj_file_name in object_file_list:
    bpy.ops.import_scene.obj(filepath="obj_models_physics/" + obj_file_name + ".obj")
    imported = bpy.context.selected_objects[0]
    objectlist.append(imported.name)

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('localhost', 20000)
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

frames = 0
image_num = len(glob.glob1("rendered_images", "image_*.png"))

# set camera
set_camera_using_intrinsics()

while True:
    # Wait for a connection
    print('waiting for a connection')
    connection, client_address = sock.accept()

    # Receive the data in small chunks and retransmit it
    data = connection.recv(4)
    print('received %s' % data)
    frames = int(data)
    print('received int %d' % frames)
    connection.close()

    # Get Pose List
    pose_list = list()
    with open(init_pose_file, "r") as file:
        for line in file:
            vals = line.split()

            m = [ (float(vals[1]), float(vals[2]), float(vals[3]), float(vals[4])),
                  (float(vals[5]), float(vals[6]), float(vals[7]), float(vals[8])),
                  (float(vals[9]), float(vals[10]), float(vals[11]), float(vals[12])),
                  (0,0,0,1)] 
            loc, rot, scale = Matrix(m).decompose()
            pose_list.append((vals[0], loc, rot))

    # Get Camera Pose List
    cam_pose_list = list()
    with open(cam_pose_file, "r") as file:
        for line in file:
            vals = line.split()

            m = [ (float(vals[0]), float(vals[1]), float(vals[2]), float(vals[3])),
                  (float(vals[4]), float(vals[5]), float(vals[6]), float(vals[7])),
                  (float(vals[8]), float(vals[9]), float(vals[10]), float(vals[11])),
                  (0,0,0,1)] 
            loc, rot, scale = Matrix(m).decompose()
            cam_pose_list.append((loc, rot))

    num_of_poses = len(pose_list)
    
    # hide all objects
    for obj in objectlist:
        objects[obj].hide = True
        objects[obj].hide_render = True
        objects[obj].location[0] = 100.0

    sceneobjectlist = list(objectlist)
    selectedobj = list()

    numberOfObjects = 0

    num = 0
    while (num < num_of_poses):
        # Load the Object in Current Scene
        shape_file = objectlist[object_file_dict[pose_list[num][0]] - 1]
        sceneobjectlist[object_file_dict[pose_list[num][0]] - 1] = shape_file
        selectedobj.append(object_file_dict[pose_list[num][0]] - 1)
        objects[shape_file].hide = False
        objects[shape_file].hide_render = False
        objects[shape_file].location = pose_list[num][1]
        objects[shape_file].rotation_mode = 'QUATERNION'
        objects[shape_file].rotation_quaternion = pose_list[num][2]

        scene.objects.active = scene.objects[shape_file]
        bpy.ops.rigidbody.object_add(type='ACTIVE')
        bpy.ops.object.modifier_add(type = 'COLLISION')
        scene.objects[shape_file].rigid_body.mass = 10.0
        scene.objects[shape_file].rigid_body.use_margin = True
        scene.objects[shape_file].rigid_body.collision_margin = 0
        scene.objects[shape_file].rigid_body.linear_damping = 1.0
        scene.objects[shape_file].rigid_body.angular_damping = 1.0

        scene.objects[shape_file].keyframe_insert(data_path="location", frame = 0, index=-1)
        scene.objects[shape_file].keyframe_insert(data_path="location", frame = 10, index=-1)
        num = num + 1
        numberOfObjects = numberOfObjects + 1

    for i in range(0,frames):
        # get camera location
        cam_location = cam_pose_list[i][0]
        cam_rotation = cam_pose_list[i][1]

        # Camera setting
        objects['Camera'].location = cam_location
        objects['Camera'].rotation_mode = 'QUATERNION'
        objects['Camera'].rotation_quaternion = cam_rotation

        # light setting
        objects['Point'].location = cam_location
        objects['Point'].rotation_mode = 'QUATERNION'
        objects['Point'].rotation_quaternion = cam_rotation
        objects['Point'].data.energy = 4

        #Rendering settings
        for area in bpy.context.screen.areas:
            if area.type == 'VIEW_3D':
                area.spaces[0].region_3d.view_perspective = 'CAMERA'
                for space in area.spaces:
                    if space.type == 'VIEW_3D':
                        space.viewport_shade = 'TEXTURED'

        #Render Post Image
        output_img = "rendered_images/rendered_image_%05i.png" % image_num
        scene.render.filepath = os.path.join(g_repo_path,"ros-packages/src/physics-scene-rendering-vision", output_img) 
        bpy.ops.render.render(write_still=True)
    
        # save to temp.blend
        # mainfile_path = os.path.join("rendered_images", "blend_%05d.blend" % image_num)
        # bpy.ops.file.autopack_toggle()
        # bpy.ops.wm.save_as_mainfile(filepath=mainfile_path)

        output_bbox = "raw_bbox_%05i.txt" % image_num
        filepath = os.path.join("rendered_images", output_bbox)
        if os.path.isfile(filepath):
            os.remove(filepath)

        num = 0
        while (num < num_of_poses):
            shape_file = objectlist[object_file_dict[pose_list[num][0]] - 1]
            x, y, width, height = write_bounds_2d(filepath, objects[shape_file])
            num = num + 1


        image_num = image_num + 1

    # Create a TCP/IP socket
    sock2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock2.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    serv_address = ('localhost', 50000)

    connected = False
    while not connected:
        try:
            sock2.connect(serv_address)
            connected = True
        except Exception as e:
            pass #Do nothing, just try again

    sock2.sendall(b'hi')
    sock2.close()
        






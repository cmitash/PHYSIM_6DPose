'''
visualize.py
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
K = Matrix(([619.444214, 0.0, 320],[0.0, 619.444336, 240],[0.0, 0.0, 1.0 ]))

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

# SHELF BASE
loc = [0,0,0]
bpy.ops.mesh.primitive_cube_add(location=loc)
bpy.context.object.dimensions = [0.43, 0.28, 0.1]
scene.objects.active = bpy.context.object
bpy.ops.rigidbody.object_add(type='ACTIVE')
bpy.ops.object.modifier_add(type = 'COLLISION')
bpy.context.object.rigid_body.enabled = False
bpy.context.object.rigid_body.use_margin = True
bpy.context.object.rigid_body.collision_margin = 0

# SHELF LEFT
loc = [0,0,0]
bpy.ops.mesh.primitive_cube_add(location=loc)
bpy.context.object.dimensions = [0.43, 0.01, 0.24]
scene.objects.active = bpy.context.object
bpy.ops.rigidbody.object_add(type='ACTIVE')
bpy.ops.object.modifier_add(type = 'COLLISION')
bpy.context.object.rigid_body.enabled = False
bpy.context.object.rigid_body.use_margin = True
bpy.context.object.rigid_body.collision_margin = 0

# SHELF RIGHT
loc = [0,0,0]
bpy.ops.mesh.primitive_cube_add(location=loc)
bpy.context.object.dimensions = [0.43, 0.01, 0.24]
scene.objects.active = bpy.context.object
bpy.ops.rigidbody.object_add(type='ACTIVE')
bpy.ops.object.modifier_add(type = 'COLLISION')
bpy.context.object.rigid_body.enabled = False
bpy.context.object.rigid_body.use_margin = True
bpy.context.object.rigid_body.collision_margin = 0

# SHELF BACK
loc = [0,0,0]
bpy.ops.mesh.primitive_cube_add(location=loc)
bpy.context.object.dimensions = [0.01, 0.28, 0.24]
scene.objects.active = bpy.context.object
bpy.ops.rigidbody.object_add(type='ACTIVE')
bpy.ops.object.modifier_add(type = 'COLLISION')
bpy.context.object.rigid_body.enabled = False
bpy.context.object.rigid_body.use_margin = True
bpy.context.object.rigid_body.collision_margin = 0

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('localhost', 10000)
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

iter_num = 1

while True:
    # Wait for a connection
    print('waiting for a connection')
    connection, client_address = sock.accept()

    # Receive the data in small chunks and retransmit it
    data = connection.recv(16)
    print('received %s' % data)
    connection.close()

    num = 0

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
            bin_position = [float(vals[13]), float(vals[14]), float(vals[15])]
            pose_list.append((vals[0], loc, rot, bin_position))

    num_of_poses = len(pose_list)
    
    # Get Bin Position
    sloc = pose_list[num][3]

    # get camera location
    cam_location = [sloc[0] - 0.4, sloc[1], sloc[2] + 0.2]
    cam_rotation = [0.542, 0.455, -0.455, -0.542]

    # Camera setting
    objects['Camera'].location = cam_location
    objects['Camera'].rotation_mode = 'QUATERNION'
    objects['Camera'].rotation_quaternion = cam_rotation

    objects["Cube"].location = [sloc[0] +0.215, sloc[1], sloc[2] - 0.06]
    objects["Cube.001"].location = [sloc[0] +0.215, sloc[1] - 0.145, sloc[2] + 0.11]
    objects["Cube.002"].location = [sloc[0] +0.215, sloc[1] + 0.145, sloc[2] + 0.11]
    objects["Cube.003"].location = [sloc[0] + 0.435, sloc[1], sloc[2] + 0.11]

    # light setting
    objects['Point'].location = cam_location
    objects['Point'].rotation_mode = 'QUATERNION'
    objects['Point'].rotation_quaternion = cam_rotation
    objects['Point'].data.energy = 4

    # hide all objects
    for obj in objectlist:
        objects[obj].hide = True
        objects[obj].hide_render = True
        objects[obj].location[0] = 100.0

    sceneobjectlist = list(objectlist)
    selectedobj = list()

    numberOfObjects = 0

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

    bpy.context.scene.frame_set(0)

    #Rendering settings
    for area in bpy.context.screen.areas:
        if area.type == 'VIEW_3D':
            area.spaces[0].region_3d.view_perspective = 'CAMERA'
            for space in area.spaces:
                if space.type == 'VIEW_3D':
                    space.viewport_shade = 'TEXTURED'
        
    
    output_img = "rendered_images/Pre_image_%05i.png" % iter_num
    scene.render.filepath = os.path.join("/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/physics-scene-rendering-vision/", output_img) 
    bpy.ops.render.render(write_still=True)

    iter_num = iter_num + 1

    # Create a TCP/IP socket
    sock2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Connect the socket to the port where the server is listening
    serv_address = ('localhost', 40000)
    sock2.connect(serv_address)
    sock2.sendall(b'helloFromPy')
    sock2.close()
        






import os
import os.path as osp
import sys
import tempfile

if os.environ.get('BLENDER_PATH') == None:
    print("Please set BLENDER_PATH in bashrc!")
    sys.exit()

g_blender_executable_path = os.environ['BLENDER_PATH']

g_blank_blend_file_path = 'blank.blend'

# call blender to correct poses
blank_file = osp.join(g_blank_blend_file_path)
# pose_correct_code = osp.join('visualize.py')
# pose_correct_code = osp.join('ComputeGradient.py')
pose_correct_code = osp.join('EnforcePhysics.py')
temp_dirname = tempfile.mkdtemp()

pose_cmd = '%s %s -b --python %s -- %s %s' % \
(g_blender_executable_path, blank_file, pose_correct_code, 'shelf', temp_dirname)
os.system(pose_cmd)

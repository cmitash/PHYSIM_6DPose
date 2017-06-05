cd(fileparts(which('poseServiceStart.m')));

addpath(genpath(pwd));

% Check installation of Robotics Addons for ROS Custom Messages
if ~exist('rosgenmsg')
    fprintf('Please download and install add-ons for Matlab Robotics System Toolbox then restart this script.\n')
    roboticsAddons
    return;
end
addpath('matlab_gen/msggen');
addpath('Utilities');
addpath('removebackground');
addpath('initializePose');
addpath('optimizePhysics');
addpath('segmentation');
addpath('segmentation/getFCNSegmentation');

% Start Matlab ROS
try
    rosinit
catch
    rosshutdown
    rosinit
end

% Load pre-scanned object models
global objNames;
global objModels;
objNames = {'barkely_hide_bones', ...
            'cherokee_easy_tee_shirt', ...
            'clorox_utility_brush', ...
            'cloud_b_plush_bear', ...
            'cool_shot_glue_sticks', ...
            'command_hooks', ...
            'crayola_24_ct', ...
            'creativity_chenille_stems', ...
            'dasani_water_bottle', ...
            'dove_beauty_bar', ...
            'dr_browns_bottle_brush', ...
            'easter_turtle_sippy_cup', ...
            'elmers_washable_no_run_school_glue', ...
            'expo_dry_erase_board_eraser', ...
            'fiskars_scissors_red', ...
            'fitness_gear_3lb_dumbbell', ...
            'folgers_classic_roast_coffee', ...
            'hanes_tube_socks', ...
            'i_am_a_bunny_book', ...
            'jane_eyre_dvd', ...
            'kleenex_paper_towels', ...
            'kleenex_tissue_box', ...
            'kyjen_squeakin_eggs_plush_puppies', ...
            'laugh_out_loud_joke_book', ...
            'oral_b_toothbrush_green', ...
            'oral_b_toothbrush_red', ...
            'peva_shower_curtain_liner', ...
            'platinum_pets_dog_bowl', ...
            'rawlings_baseball', ...
            'rolodex_jumbo_pencil_cup', ...
            'safety_first_outlet_plugs', ...
            'scotch_bubble_mailer', ...
            'scotch_duct_tape', ...
            'soft_white_lightbulb', ...
            'staples_index_cards', ...
            'ticonderoga_12_pencils', ...
            'up_glucose_bottle', ...
            'woods_extension_cord', ...
            'womens_knit_gloves'};
objModels = cell(1,length(objNames));
fprintf('Loading pre-scanned object models...\n');
for objIdx = 1:length(objNames)
  try
    fprintf('    %s\n',objNames{objIdx});
    objModels{objIdx} = pcread(sprintf('models/objects_pracsys/%s.ply',objNames{objIdx}));
  end
end

% Load pre-scanned empty shelf bins
global emptyShelfModels;
emptyShelfModels = cell(1,12);
binIds = 'ABCDEFGHIJKL';
fprintf('Loading pre-scanned empty shelf bins...\n');
for binIdx = 1:length(binIds)
    emptyShelfModels{binIdx} = pcread(sprintf('models/bins/bin%s.ply',binIds(binIdx)));
end

% Setup CUDA KNNSearch Kernel Function
global KNNSearchGPU;
tic;
fprintf('Setting up CUDA kernel functions...\n');
KNNSearchGPU = parallel.gpu.CUDAKernel('KNNSearch.ptx','KNNSearch.cu');
toc;

% Configuration options
global usePhysics;
global physicsIterations;
global physicsstep;
global finalstep;
global SegMode;
global InitPoseMode;
global calibBin;
global binBounds;
global tableBounds;
global gridStep;
global useBgCalib;
global detThreshold;
global debugOption;
global useSceneOptimizer;
global sceneDepth;
global transOffset;
global rotOffset;

% Generic
SegMode = 'rcnn'; % choose between rcnn, fcn, gt (ground truth)
InitPoseMode= 'super4pcs'; % choose between super4pcs, pca, fgr
calibBin = 0; % Should be enabled for Princeton Dataset
binBounds = [-0.005, 0.40; -0.13, 0.11; -0.01, 0.20]; % points outside this bound would be removed if using shelf
tableBounds = 0.528; % points below this bound would be removed if using table
gridStep = 0.002; % grid size for downsampling point clouds
useBgCalib = 1; % if you want to use background calibration of bin/table
detThreshold = 0.3; % threshold on rcnn confidence to be considered as a correct detection
debugOption = 1; % store intermediate point clouds

% for PHYTrimICP
usePhysics = 0; % If you want to use physics in postprocessing
physicsIterations = 3; % Number of iterations of physics and ICP that will be used
physicsstep = 5; % Number of steps in each iteration of physics
finalstep = 20; % Number of steps in final physics step

% for global search
useSceneOptimizer = 0;
transOffset = 0.02;
rotOffset = 0.0872665; % radians for 5 degrees

% Start ROS service
server = rossvcserver('/pose_estimation', 'pose_estimation/EstimateObjectPose', @poseServiceIterative);
fprintf('Ready.\n');

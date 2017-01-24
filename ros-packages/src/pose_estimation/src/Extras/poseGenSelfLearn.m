clc;

objname = {'crayola_24_ct', 'expo_dry_erase_board_eraser', 'folgers_classic_roast_coffee',...
  'scotch_duct_tape', 'up_glucose_bottle', 'laugh_out_loud_joke_book', 'soft_white_lightbulb',...
  'kleenex_tissue_box', 'dove_beauty_bar', 'elmers_washable_no_run_school_glue', 'rawlings_baseball'};

objdatasize = {234, 35, 192, 95, 112, 33, 158, 151, 185, 89, 46};

for obj=11:11
    for scenenum=30:objdatasize{1,obj}
        currentScene = sprintf('/media/pracsys/DATA/iros17/training/shelf/%s/scene-%04d',objname{1,obj}, scenenum-1);
        calibPath = '/home/pracsys/github/apc-vision-toolbox/data/benchmark/office/calibration'; 

        [client,reqMsg] = rossvcclient('/pose_estimation');

        fprintf('calling pose estimation for scene %d \n', scenenum-1);
        reqMsg.SceneFiles = currentScene;
        reqMsg.CalibrationFiles = calibPath;
        response = call(client,reqMsg);
    end
end
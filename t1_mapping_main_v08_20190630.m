% T1 mapping via from variable flip angle measurement
%
% File created by Mehrdad Pourfathi on 2/17/2019.
%
% File updated by Mehrdad Pourfathi on 6/30/2019.

%% Basic Input/Ouput Parameters
% Pre and Post file paths (make sure that there is "/" at the end of the
% main path name!)
% Folder names should be just the flip angle
% pre_path = '/Users/mehipour/Library/Mobile Documents/com~apple~CloudDocs/Data/Cancer Project with Rutgers/20190220-Phantom/VFA selected images 2-19-2019/';
% post_path = '/Users/mehipour/Library/Mobile Documents/com~apple~CloudDocs/Data/Cancer Project with Rutgers/20190220-Phantom/VFA selected images 2-19-2019/';

close all
% animal
pre_path = '/Users/mehipour/Documents/GitHub.nosync/t1_mapping/data/DCE and T1 mapping_OVASC1_2 Xenografts/T1 mapping/VFA Before Magnevist inj/VFA ';
post_path = '/Users/mehipour/Documents/GitHub.nosync/t1_mapping/data/DCE and T1 mapping_OVASC1_2 Xenografts/T1 mapping/VFA AFter Magnevist inj/VFA ';

% Basic MRI paramaeters
% FA = [5 8 13 18 25 30 35 60 160];
FA = [5 8 13 25 60 160];
Nslice = 5;
Gd_relaxivity = 1;     % [L/(mmol . s)]

% Fitting Flags
show_fitting = 1;      % If 1 then show fitting for each voxel. Code runs faster and it only shows a progress bar

% Processing flags
pre = 1;              % 1 if pre-Gd data is available
post = 1;             % 1 if post-Gd data is available, set to 0 to test phantoms
gaussian_filter = 1;  % If 1 then apply a gaussian filter for smoothing
sigma_gaussian = 1; % Standard deviation for the gauassian fitler, larger value means more blurring.
threshold = 0.15;     % Threshold set to ignore voxels values less than [threshold x (maxium image intensity)], 0 means no thresholding
manual_R1_segementation = 0; % if 1 then can manually segment each R1 map
manual_c_segmentation = 1;   % if 1 then can manually segment c image

% The code first checks if R1 maps were already produced, if so it does
% not fit and laods the data. Setting this flag to 1 performs the fit
% regardless and overrides the data
fit_override = 0;  
% filename to save R1 maps, files will be saved in the main main file path
% for each study
pre_file_name = 'Pre R1 maps';
post_file_name = 'Post R1 maps';

%% Process Pre-Gd Data
if pre
    % check if R! maps are available, otherwise fit
    disp('Processing Pre-Gd Data...');
    data_available = check_for_r1_data_v01_20190630(pre_path,pre_file_name);
    if or(~data_available,fit_override)
        [masked_pre_img,tr,te] = read_filter_organize_and_threshold_images_v01_20190630(FA, pre_path, gaussian_filter, sigma_gaussian, threshold);
        pre_r1_map = generate_r1_maps_v01_20190630(masked_pre_img, FA, tr, show_fitting);
        save(strcat(find_file_path_v01_20190630(pre_path),pre_file_name,'.mat'),'pre_r1_map');        
    else
        load(strcat(find_file_path_v01_20190630(pre_path),pre_file_name,'.mat'));
        if manual_R1_segementation
            segment_then_find_mean_and_sd_v01_20190630(pre_r1_map,pre_path,pre_file_name);
        end
    end
    % show pre R1 maps
    figure('name','Pre R1 Map'); 
    show_multislice_maps_v01_20190630(pre_r1_map,'jet',[0 20]);
end

%% Process Post-Gd Data
if post
    disp('Processing Post-Gd Data...');
    % check if R1 maps are available, otherwise fit
    data_available = check_for_r1_data_v01_20190630(post_path,post_file_name);
    if or(~data_available,fit_override)
        [masked_post_img,tr,te] = read_filter_organize_and_threshold_images_v01_20190630(FA, post_path, gaussian_filter, sigma_gaussian, threshold);
        post_r1_map = generate_r1_maps_v01_20190630(masked_post_img, FA, tr, show_fitting);
        save(strcat(find_file_path_v01_20190630(post_path),post_file_name,'.mat'),'post_r1_map');        
    else
        load(strcat(find_file_path_v01_20190630(post_path),post_file_name,'.mat'));
        if manual_R1_segementation
            segment_then_find_mean_and_sd_v01_20190630(post_r1_map,post_path,post_file_name);
        end
    end
    % show pre R1 maps
    figure('name','Post R1 Map'); 
    show_multislice_maps_v01_20190630(post_r1_map,'jet',[0 20]);
end

%% Create Gd Concentration Maps (only will run if pre and post maps are selected)
if and(pre,post)
    c = estimate_gd_concentration_v01_20190630(pre_r1_map,post_r1_map,Gd_relaxivity,0,0);
    if manual_c_segmentation
        segment_then_find_mean_and_sd_v01_20190630(c,pre_path,'gd concentartion')
    end
    figure('name','Gd Concentration Map (mM)')
    show_multislice_maps_v01_20190630(c,'jet',[0  10]);
end
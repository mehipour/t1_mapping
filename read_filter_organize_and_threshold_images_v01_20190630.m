function [masked_img,tr,te] = read_filter_organize_and_threshold_images_v01_20190630(FA,path,gaussian_filter,sigma_gaussian,threshold)
%
% syntax: [masked_img,tr,te] = read_filter_organize_and_threshold_images_version_date(FA,path,gaussian_filter,sigma_gaussian,threshold)
%
% File craeted by Mehrdad Pourfathi on 6/30/2019
% 
% Input:
%   This fuction reads a flip angle list and a the path to the main folder 
%   with images, images for each flip angle must be in the name folder and
%   named with a number indicating the flip anlge for this function to work 
%   correctly.
%
% Ouput: 
%   Returns the smoothed (if filtered with a gaussian fiter) and thresholded
%   images as well as the necessary imaging parametres, e.g. repetiton time,
%   echo time and image size.
%%
    for fa_counter = 1:length(FA)   
        % read pre images for each flip angle
        image_counter = 0;  % counts ".dcm" files
        folder_path = [path,num2str(FA(fa_counter))];
        file = dir(folder_path);   

        % image loop within folder
        for jj = 1:numel(file)
            % check if file type is dicom
            if ~and(isempty(strfind(file(jj).name,'.dcm')), isempty(strfind(file(jj).name,'.DCM')))
                image_counter = image_counter + 1;  % if the file name included 'slice'
                image_path = [folder_path '/' file(jj).name];
                img = im2double(dicomread(image_path));
                if gaussian_filter
                    img = imgaussfilt(img,sigma_gaussian);
                end
                % threshold from the lowest flip angle image for each slice
                if fa_counter == 1
                    [masked_img(:,:,image_counter,fa_counter),mask(:,:,image_counter)] = threshold_image(img,threshold);
                elseif fa_counter > 1
                    masked_img(:,:,image_counter,fa_counter) = img.*squeeze(mask(:,:,image_counter));
                end
                
                % get image info from the metadata
                img_info = dicominfo(image_path);
            end
        end 
    end

    % read imaging parameters from DICOM metadata
    tr = img_info.RepetitionTime/1000; % repetition time in seconds
    te = img_info.EchoTime/1000;       % echo time in seconds.
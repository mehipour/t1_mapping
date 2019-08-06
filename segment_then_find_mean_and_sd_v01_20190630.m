function segment_then_find_mean_and_sd_v01_20190630(img,path,filename)
%
% segment_tumors_v01_20190630(img,path)
%
% File created by Mehrdad Pourfathi on 6/30/2019
%
% Takes an image and requests user how many tumors are to be segmented.
% 
% Input:
%   image
%
% Ouput: 
%   mean and sd of image
%%
%% edited by Mehrdad Pourfathi on 8/5/2019
% shows the log of image when selecting ROI.

% segmentation file name
segmentation_file = strcat(filename,' segmentation');
path = find_file_path_v01_20190630(path);
segmentation_file_path = strcat(path,segmentation_file,'.mat');
Nslice = size(img,3);

% check if segmentation file already exists
if ~exist(segmentation_file_path,'file')
    % define structure
    mask = struct('slice','','reg','');
    reg = struct('region','','mask','','mean','','std','');

    % find the number of tumors
    fprintf('\nCount tumors from top-left clockwise...\n')
    n_tumor = input('how many tumors does this mouse have?    n = ');
    fprintf('\n')
        
    % loop over slides
    for slice_loop = 1:Nslice

        % define regions
        reg = {};
        for tumor_loop = 1:n_tumor
            reg(tumor_loop) = {strcat('tumor-',num2str(tumor_loop))};
        end

        % use the overlaid pyruvate map
        figure('name','Segment from here') 
        imagesc(1+log(img(:,:,slice_loop)));
        
        % loop over the regions
        for region_loop = 1:length(reg)

            % write the region in the structure
            mask(slice_loop).reg(region_loop).region = cell2mat(reg(region_loop));

            % print the region to be selected
            fprintf(['select the ',cell2mat(reg(region_loop)),' region\n']); 

            % select the region
            [m,x,y] = roipoly;
            mask(slice_loop).reg(region_loop).mask = double(m);

            % make all zeros equal to NaN      
            mask(slice_loop).reg(region_loop).mask(mask(slice_loop).reg(region_loop).mask==0) = NaN;
        end
    end
    % save masks
        save(segmentation_file_path,'mask','n_tumor');        

else
    % if the quantificaiton mask exists, load the file
    load(segmentation_file_path);
end


%% Quantification
for slice_loop = 1:Nslice
    for region_loop = 1:n_tumor

        aux = nanmean(mask(slice_loop).reg(region_loop).mask .* img(:,:,slice_loop));
        mask(slice_loop).reg(region_loop).mean = nanmean(aux(:));
        mask(slice_loop).reg(region_loop).std = nanstd(aux(:));

        fprintf('Slice    Region      mean       SD \n');
        fprintf('  %1.0f     %s    %4.4f   %4.4f \n\n',...
            slice_loop, mask(slice_loop).reg(region_loop).region, ....
            mask(slice_loop).reg(region_loop).mean, ...
            mask(slice_loop).reg(region_loop).std);
    end
end




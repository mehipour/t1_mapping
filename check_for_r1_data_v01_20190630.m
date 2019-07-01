function [data_available] = check_for_r1_data_v01_20190630(path,file_name)
%
% syntax: [data_available,r1_map] = check_for_r1_data_v01_20190630(path,file_name)
%
% Checks for previously fitted r1 maps, loads if avaialble
%
% File created by Mehrdad Pourfathi on 6/30/2019
% 
% Input:
%   image path folder and the desired file name
%
% Ouput: 
%   a flag indicating whether data exists and r1 map
%% 
path = find_file_path_v01_20190630(path);
r1_map_path = strcat(path,file_name,'.mat');
if exist(r1_map_path)
    data_available = 1;
else
    data_available = 0;
end


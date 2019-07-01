function out_path = find_file_path_v01_20190630(in_path) 
%
% out_path = find_file_path_v01_20190630(in_path)  
%
% File created by Mehrdad Pourfathi on 6/30/2019
%
% finds the path that ends with '/'
%%
idx = strfind(in_path,'/');
out_path = in_path(1:idx(end));
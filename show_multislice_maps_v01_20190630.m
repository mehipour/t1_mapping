function show_multislice_maps_v01_20190630(img,color_map,range)
%
% syntax: show_multislice_maps_v01_20190630(img,color_map,range);
%
% Plots Images
%
% File created by Mehrdad Pourfathi on 6/30/2019
% 
% Input: Image, colormap and range
%% 

Nslice = size(img,3);
[Ny,Nx] = select_subplot_number(Nslice);

for slice_counter = 1:Nslice
    subplot(Nx,Ny,slice_counter)
    imagesc(img(:,:,slice_counter));
    colormap(color_map); colorbar; axis square;
    caxis([range(1) range(2)]);
    title([strcat('Slice # ',num2str(slice_counter))]);
end


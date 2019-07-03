function [Nx,Ny] = select_subplot_number(Nimg)
% Syntax [Nx,Ny] = select_subplot_number(Nimg)
% Selects subplot size depending on the number of images.
%
% Create by Mehrdad Pourfathi on 12/18/2013.
%
%
Nx = ceil(sqrt(Nimg));
Ny = ceil(Nimg/Nx);


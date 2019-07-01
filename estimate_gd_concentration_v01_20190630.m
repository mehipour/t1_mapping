function c = estimate_gd_concentration_v01_20190630(pre_r1_map, post_r1_map, Gd_relaxivity,xshift,yshift)  
%
% c = estimat_gd_concentration_v01_20190630(pre_r1_map, post_r1_map, Gd_relaxivity,xshift,yshift) 
%
% File created by Mehrdad Pourfathi on 6/30/2019
%
% finds concentration of Gd from pre and post R1 maps using the following
% equations: 
% R1,post = R1,Pre + [Gd] x Gd_relaxivity
% 
% Input:
%   Pre and post Gd r1 maps, Gd relaxivity and x and y shifts if images do
%   ont line up.
%
% Ouput: 
%   Gd Concentration map (mM)
%%
    sub_img = post_r1_map - circshift(circshift(pre_r1_map,yshift,1),xshift,2);
    c = sub_img / Gd_relaxivity;

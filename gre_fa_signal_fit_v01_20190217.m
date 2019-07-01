function [fitresult, gof] = gre_fa_signal_fit_v01_20190217(FA, signal_pre,tr)
%
% Syntax [fitresult, gof] = gre_fa_signal_fit_v01_20190217(FA, signal_pre,tr)
%
% Created using MATLAB's Curve Fitting Toolbox by Mehrdad Pourfathi in
% 02/17/2019
%
% equation from "Estimating T1 from Multichanlle Variable Flip Angle SPGR
% Sequences", by Joshua D Trzasko, et al, MRM 69:1787-1794 (2013)


%% Fit: 'SPGR Fit'
[xData, yData] = prepareCurveData( FA, signal_pre );

% Set up fittype and options.
ft = fittype( ['m*sind(x)* (1-exp(-' num2str(tr) '*r1) ) / (1-cosd(x)*exp(-' num2str(tr) '*r1))'], 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [1 10];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts);


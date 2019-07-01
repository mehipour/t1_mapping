function r1_map = generate_r1_maps_v01_20190630(img,FA,tr,show_fitting)
%
% syntax: r1_map = generate_r1_maps_v01_20190630(img,FA,tr)
%
% File created by Mehrdad Pourfathi on 6/30/2019
% 
% Input:
%   Organized images for different slice, a list of flip angles and the
%   repeition time of the scan.
%
% Ouput: 
%   R1 Maps
%% 
    % load variables
    [nx,ny,Nslice,~] = size(img);
    signal = zeros(1,length(FA));
    r1_map = zeros(ny,nx,Nslice);
    m_map = r1_map;

    % go through individual voxels
    for slice_counter = 1:Nslice
        if ~show_fitting
            h = waitbar(0,strcat(['Processing Slice ',num2str(slice_counter),'...']));
        end
        for x_counter = 1:nx
            if ~show_fitting
                waitbar(x_counter/nx);
            end
            for y_counter = 1:ny    
                
                % if voxel is noise then move to the next voxel
                if isnan(img(y_counter,x_counter,slice_counter,1))
                    continue
                end
                
                % signal trend vs. FA
                for fa_counter = 1:length(FA)
                    signal(fa_counter) = squeeze(img(y_counter,x_counter,slice_counter,fa_counter));
                end

                % Fit signal for each voxel
                [fit_param, ~] = gre_fa_signal_fit_v01_20190217(FA, signal, tr);
                m = fit_param.m; r1 = fit_param.r1;
                fit_signal = m * (sind(FA)*(1-exp(-tr*r1)))./(1-cosd(FA)*exp(-tr*r1));

                % store pre r1 and m maps
                r1_map(y_counter,x_counter,slice_counter) = r1;
                m_map(y_counter,x_counter,slice_counter) = m;     

                % plot signal vs. FA for each voxel for each slices
                if show_fitting
                    figure (220);
                    % show voxel fitted
                    subplot(2,2,1);
                    imagesc(img(:,:,slice_counter)); hold on;  
                    plot(x_counter,y_counter,'rs'); % plot red box over the voxel that is being fitted
                    hold off; axis square;
                    title(strcat(['Image for slice number ',num2str(slice_counter)]));

                    % show signal vs. flip angle
                    subplot(1,2,2);
                    plot(FA,signal,'ro',FA,fit_signal,'LineWidth',2); 
                    xlabel('Flip Angle (degrees)'); ylabel('Signal intensity (a.u.)');
                    title(['Slice Number ', num2str(slice_counter), ', Estimated T1 =', num2str(1/r1)]);
                    ylim([0 max(img(:))]);

                    % show T1 map
                    subplot(2,2,3);
                    imagesc(r1_map(:,:,slice_counter)); axis square;
                    title(strcat(['T1 Map of slice number ',num2str(slice_counter)]));
                    colorbar; colormap jet;
                    drawnow;
                end
            end
        end
        if ~show_fitting
            close(h);
        end
    end

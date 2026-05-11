% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Yiqian Yang, Liangcai Cao*
% %State Key Laboratory of Precision Measurement Technology and Instruments, Department of Precision Instruments, Tsinghua University, Beijing 100084, China
% %yang-yq22@mails.tsinghua.edu.cn
% %clc@tsinghua.edu.cn
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % The code is written by Yiqian Yang 2026
% % The software is Matlab R2024a

clc;clear;close all

x_0 = 63;
y_0 = 63;

path = ['E:\EMCCD\4bin_200mW_10ms_3000_X'];

PSF_M = 20;
for i = 1:1
    i
    I = fitsread([path,num2str(i),'.fits']);
   
    [M,N,F] = size(I);
    ymax = 1;
    ymin = 0;

    Imax = (max(I,[],[1,2]));    
    Imin = (min(I,[],[1,2]));
    I_2 = (ymax-ymin)*(I-Imin)./(Imax-Imin) + ymin;
    A(:,:,i) = double((mean(I_2,3)));
    clear I_2


    Imax = max(I,[],3);      
    Imin = min(I,[],3);
    I_1 = (ymax-ymin)*(I-Imin)./(Imax-Imin) + ymin;
    clear I
    I_GPU = gpuArray(single(I_1));
    clear I_1 

    
    state = regionprops(imbinarize(A));
    for ii = 1:length(state)
        Area_I(ii) = state(ii).Area;
        centroids{ii} = state(ii).Centroid;
    end
    [~,pos] = find(Area_I == max(Area_I));
    centroid_x_y = centroids{pos};
    x_0 = round(centroid_x_y(1));
    y_0 = round(centroid_x_y(2));
    
    [~, PSF_s(:,:,i),Frame] = Corr_mom(I_GPU, PSF_M, x_0, y_0);
    clear I_GPU

end

Frame
I_mean = mean(A,3);
PSF_mean = mean(PSF_s,3);

PSFmax = max(max(PSF_mean));
PSFmin = mean(mean(PSF_mean(1:5,1:5)));
ymax = 1;
ymin = 0;
PSF_mean = (ymax-ymin)*(PSF_mean-PSFmin)./(PSFmax-PSFmin) + ymin;

x1_puls_x2 = (-PSF_M:PSF_M);
y1_puls_y2 = (-PSF_M:PSF_M);
kx1_puls_kx2 = x1_puls_x2*4*16e-6/35e-3*2*pi/810e-9/2/1e6;
ky1_puls_ky2 = y1_puls_y2*4*16e-6/35e-3*2*pi/810e-9/2/1e6;% um-1  % 角波数 k = (2π / λ) * (x / f) * M


figure,
subplot(121)
imagesc(I_mean)
set(gca,'YDir','normal')
colorbar

subplot(122)
imagesc(x1_puls_x2, y1_puls_y2, PSF_mean)
colorbar
set(gca,'YDir','normal')


figure
surf(x1_puls_x2, y1_puls_y2, PSF_mean,'EdgeColor','none');
xlabel( 'x1+x2', 'Interpreter', 'none' );
ylabel( 'y1+y2', 'Interpreter', 'none' );
zlabel( 'PSF_mean', 'Interpreter', 'none' );
grid on
view( -44.8, 12.0 );

PSF_x = PSF_mean(PSF_M,:);
PSF_y = PSF_mean(:,PSF_M);


figure,
subplot(121),plot(PSF_mean(PSF_M,:))
subplot(122),plot(PSF_mean(:,PSF_M))

%%
[xData, yData, zData] = prepareSurfaceData( x1_puls_x2, y1_puls_y2, PSF_mean );

ft = fittype( 'a*exp(-(x-x0)^2/bx^2-(y-y0)^2/by^2)+c', 'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.StartPoint = [1 0.4 0.8 0 0 0];


[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

figure
x_fit = (-30:0.001:30);
y_fit = (-30:0.001:30);

psf_x_fit = fitresult.a*exp(-((x_fit-fitresult.x0).^2)/fitresult.bx^2)+fitresult.c;
psf_y_fit = fitresult.a*exp(-((y_fit-fitresult.y0).^2)/fitresult.by^2)+fitresult.c;
FWHM_x = fitresult.bx*2*sqrt(log(2));
FWHM_y = fitresult.by*2*sqrt(log(2));

subplot(121)
plot(x_fit, psf_x_fit)
subplot(122)
plot(y_fit, psf_y_fit)


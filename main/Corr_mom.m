% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Yiqian Yang, Liangcai Cao*
% %State Key Laboratory of Precision Measurement Technology and Instruments, Department of Precision Instruments, Tsinghua University, Beijing 100084, China
% %yang-yq22@mails.tsinghua.edu.cn
% %clc@tsinghua.edu.cn
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % The code is written by Yiqian Yang 2026
% % The software is Matlab R2024a

function [I_sum, PSF_mean,Frame] = Corr_mom(I_GPU, PSF_M, x_0, y_0)


[M,N,Frame] = size(I_GPU);
Frame
num = 0;
for Ref_point_x = 1:M
    for Ref_point_y = 1:M
        if ( (Ref_point_x-x_0)^2 + (Ref_point_y-y_0)^2 < 30^2 ) && ( (Ref_point_x-x_0)^2 + (Ref_point_y-y_0)^2 > 20^2 ) %&& (Ref_point_x>x_0)
            num = num+1

            x_start = 2*y_0-Ref_point_y-PSF_M;
            x_end = 2*y_0-Ref_point_y+PSF_M;
            y_start = 2*x_0-Ref_point_x-PSF_M;
            y_end = 2*x_0-Ref_point_x+PSF_M;  


            %%
            Gama_1 = I_GPU(Ref_point_y,Ref_point_x,:);
            Gama_2 = I_GPU(x_start+1:x_end+1,y_start+1:y_end+1,:);
            Gama_1_mean = mean(Gama_1,3);
            Gama_2_mean = mean(Gama_2,3);
            PSF(:,:,num) = (mean((Gama_1 - Gama_1_mean) .* (Gama_2 - Gama_2_mean),3));

             
        end
    end
     
end
I_sum = mean(I_GPU,3);
I_sum = double(gather(I_sum));

PSF_mean = mean((PSF),3);
PSF_mean = double(gather(PSF_mean));

clear Gama_1_mean Gama_2_mean Gama_1 Gama_2 PSF I_GPU
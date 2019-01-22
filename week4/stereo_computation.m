function [disparity] = stereo_computation(imgL,imgR, minDisp, maxDisp, wSize, cost)
%STEREO_COMPUTATION computes the disparity
% between a pair of rectified images using a local method based on a matching cost 
% between two local windows.
% 
% The input parameters:
% - left image
% - right image
% - minimum disparity
% - maximum disparity
% - window size (e.g. a value of 3 indicates a 3x3 window)
% - matching cost (the user may able to choose between SSD and NCC costs)

if (size(imgL,3) == 3)
    imgL = sum(imgL, 3) / 3;
end
if (size(imgR,3) == 3)
    imgR = sum(imgR, 3) / 3;
end 


[nrows, ncols] = size(imgL);
step = (wSize-1)/2;
disparity = zeros(size(imgL,1), size(imgL,2));


for j =1+step:(nrows-step)
    for i=(1+step):(ncols-step-maxDisp)
        template = imgR(j-step:j+step,i-step:i+step);
        rowCorr = zeros(maxDisp-minDisp+1,1);
        for d = minDisp:maxDisp
            if(strcmp(cost,'SSD'))
                rowCorr(d+1)=ssd_cost(template, imgL(j-step:j+step, i-step+d:i+step+d));
            end
            if(strcmp(cost,'NCC'))
                rowCorr(d+1)=ncc_cost(template, imgL(j-step:j+step, i-step+d:i+step+d));
            end
            if(strcmp(cost,'SSD_bilateral'))
                rowCorr(d+1)=bilateral_weights_cost(template, imgL(j-step:j+step, i-step+d:i+step+d),d, 'SSD');
            end
            if(strcmp(cost,'NCC_bilateral'))
                rowCorr(d+1)=bilateral_weights_cost(template, imgL(j-step:j+step, i-step+d:i+step+d),d, 'NCC');
            end
        end
        if(strcmp(cost,'NCC') || strcmp(cost,'NCC_bilateral'))
            [~, idx] = max(rowCorr);
        else
            [~, idx] = min(rowCorr);
        end
        disparity(j,i)=idx-1;
    end
end

end


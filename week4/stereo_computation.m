function [disparity] = stereo_computation(imgL,imgR, minDisp, maxDisp, wSize, cost)
%STEREO_COMPUTATION Summary of this function goes here
%   Detailed explanation goes here
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
            if(cost == 'NCC')
                rowCorr(d+1)=ncc_cost(template, imgL(j-step:j+step, i-step+d:i+step+d));
            else
                rowCorr(d+1)=ssd_cost(template, imgL(j-step:j+step, i-step+d:i+step+d));
            end
        end
        if(cost == 'NCC')
            [~, idx] = max(rowCorr);
        else
            [~, idx] = min(rowCorr);
        end
        disparity(j,i)=idx-1;
    end
end

end


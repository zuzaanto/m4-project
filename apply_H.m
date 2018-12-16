function [dst] = apply_H(src,H)
%APPLY_H Perform transformation using provided homography matrix

src = im2double(src);

Ni = size(src,1);
Nj = size(src,2);

src_coord = zeros(3,1);
% create matrix for storing output corner coordinates
dst_coord_float = zeros(3,4);
% compute coordinates of the corners of the transformed image
index = 1;
for i=1:Ni-1:Ni
    for j=1:Nj-1:Nj
        src_coord(1) = j;
        src_coord(2) = i;
        src_coord(3) = 1;
        dst_coord_float(:,index) = H*src_coord;
        index = index+1;
    end
end
minX = min(dst_coord_float(1,:));
maxX = max(dst_coord_float(1,:));
minY = min(dst_coord_float(2,:));
maxY = max(dst_coord_float(2,:));

paddingLeft = 0;
paddingRight = 0;
paddingTop = 0;
paddingBottom = 0;

if minX < 0
    paddingLeft = round(-minX);
end
if maxX > Nj
    paddingRight = round(maxX) - Nj;
end 
if minY < 0
    paddingTop = round(-minY);
end
if maxY > Ni
    paddingBottom = round(maxY) - Ni;
end
newXrange = paddingLeft + Nj + paddingRight;
newYrange = paddingTop + Ni + paddingBottom;
srcPadded = zeros(newYrange, newXrange, 3);
srcPadded(paddingTop+1: paddingTop + Ni, paddingLeft+1:paddingLeft + Nj,:) = src;


newNi = size(srcPadded,1);
newNj = size(srcPadded,2);
dst = zeros(newNi,newNj,3);

% dst = zeros(Ni,Nj,3);
dst_coord = zeros(3,1);
% src_coord = zeros(1,Ni*Nj);

[Xsrc, Ysrc] = meshgrid(-paddingLeft + 1:Nj + paddingRight, -paddingTop + 1:Ni + paddingBottom);
[Xsrc_float, Ysrc_float] = meshgrid(1:newNj, 1:newNi);


for i=1:newNi
    for j=1:newNj
        dst_coord(1) = j-paddingLeft;
        dst_coord(2) = i-paddingTop;
        dst_coord(3) = 1;
        src_coord_float = (H)\dst_coord;
        Xsrc_float(i,j) = src_coord_float(1);
        Ysrc_float(i,j) = src_coord_float(2);
    end
end
% figure; imshow(uint8(srcPadded*255));
%interpolation for each channel: r
dst(:,:,1) = interp2(Xsrc,Ysrc, srcPadded(:,:,1), Xsrc_float, Ysrc_float);
dst(:,:,2) = interp2(Xsrc,Ysrc, srcPadded(:,:,2), Xsrc_float, Ysrc_float); 
dst(:,:,3) = interp2(Xsrc,Ysrc, srcPadded(:,:,3), Xsrc_float, Ysrc_float); 

if maxX<Nj
    dst = dst(:,1:paddingLeft + round(maxX),:);
end
if maxY<Ni
    dst = dst(1:paddingTop+round(maxY),:,:);
end
if minX>0
    dst = dst(:,round(minX):end,:);
end   
if minY>0
    dst = dst(round(minY):end,:,:);
end    
dst = fillmissing(dst, 'constant', 0);
dst = dst*255;
%         x_src1 = src(ceil(x_src(1)), ceil(x_src(2));
%         x_src2 = src(floor(x_src(1)), ceil(x_src(2));
%         x_src3 = src(ceil(x_src(1)), floor(x_src(2));
%         x_src4 = src(floor(x_src(1)), floor(x_src(2));

end


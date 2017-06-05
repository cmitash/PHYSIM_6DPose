function sceneDepth = renderDepth(sceneData, camPts, spath)

pixPts = sceneData.colorK*camPts;
pixX = int16(pixPts(1,:)./pixPts(3,:));
pixY = int16(pixPts(2,:)./pixPts(3,:));
depthval = pixPts(3,:);

depthImg = zeros(480,640);
for i =1:size(pixX,2)
    if(pixX(1,i) > 0 & pixX(1,i) < 640 & pixY(1,i) >0 & pixY(1,i) < 480)
    	if depthImg(pixY(1,i), pixX(1,i)) ~= 0
    		minval = min([depthImg(pixY(1,i), pixX(1,i)) depthval(1,i)]);
        	depthImg(pixY(1,i), pixX(1,i)) = minval;
        else
        	depthImg(pixY(1,i), pixX(1,i)) = depthval(1,i);
        end
    end
end
depthImg = fillHoles(depthImg);
% depthImg = imgaussfilt(depthImg, 3);
sceneDepth = depthImg;
writeDepth(depthImg, spath)

end
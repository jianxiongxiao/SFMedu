function pair = match2viewSURF(frames, frameID_i, frameID_j)

% Tested on Matlab r2014a with Computer Vision System Toolbox

% Similar to image stiching, but instead of homograph, we estimate the fundamental matrix

colorA = imresize(imread(frames.images{frameID_i}),frames.imsize(1:2));
colorB = imresize(imread(frames.images{frameID_j}),frames.imsize(1:2));


pair.frames = [frameID_i, frameID_j];

imageA  = rgb2gray(colorA);
imageB  = rgb2gray(colorB);

ptsA = detectSURFFeatures(imageA,'MetricThreshold',100);
ptsB = detectSURFFeatures(imageB,'MetricThreshold',100);

[featuresA, validPtsA] = extractFeatures(imageA, ptsA);
[featuresB, validPtsB] = extractFeatures(imageB, ptsB);

index_pairs = matchFeatures(featuresA, featuresB,'Method','NearestNeighborSymmetric','MatchThreshold',2);
matchedPtsA = validPtsA(index_pairs(:,1));
matchedPtsB = validPtsB(index_pairs(:,2));

figure; 
showMatchedFeatures(imageA,imageB,matchedPtsA,matchedPtsB,'montage');
title('Matched SURF points, including outliers');

matchedPtsA = [size(colorA,2)/2-matchedPtsA.Location(:,1) size(colorA,1)/2-matchedPtsA.Location(:,2)];
matchedPtsB = [size(colorB,2)/2-matchedPtsB.Location(:,1) size(colorB,1)/2-matchedPtsB.Location(:,2)];

pair.matches = [matchedPtsA'; matchedPtsB'];


%{
for i=1:length(matchedPtsA)
    matchedPtsA(i).Location = [size(colorA,2)/2-matchedPtsA(i).Location(1)  size(colorA,1)/2-matchedPtsA(i).Location(2)];
end

matchedPtsB.Location(:,1) = size(colorB,2)/2-matchedPtsB.Location(:,1);
matchedPtsB.Location(:,2) = size(colorB,1)/2-matchedPtsB.Location(:,2);
%}

%[fRANSAC,inlierPts] = estimateFundamentalMatrix(matchedPtsA,matchedPtsB,'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 0.2);
%pair.F = fRANSAC;
%inlierPtsA = matchedPtsA(inlierPts,:);
%inlierPtsB = matchedPtsB(inlierPts,:);
%pair.matches = [inlierPtsA'; inlierPtsB'];


figure
imshow(colorA);
hold on
plot(size(colorA,2)/2-pair.matches(1,:),size(colorA,1)/2-pair.matches(2,:),'r+');
figure
imshow(colorB);
hold on
plot(size(colorB,2)/2-pair.matches(3,:),size(colorB,1)/2-pair.matches(4,:),'r+');


function pair = match2viewSIFT(frames, frameID_i, frameID_j)

% SFMedu: Structrue From Motion for Education Purpose
% Written by Jianxiong Xiao (MIT License)

%% load two images and depths
image_i=imresize(imread(frames.images{frameID_i}),frames.imsize(1:2));
image_j=imresize(imread(frames.images{frameID_j}),frames.imsize(1:2));


pair.frames = [frameID_i, frameID_j];

%% compute SIFT keypoints
  
edge_thresh = 2.5;
[SIFTloc_i,SIFTdes_i] = vl_sift(single(rgb2gray(image_i)), 'edgethresh', edge_thresh) ;
SIFTloc_i = SIFTloc_i([2,1],:);
[SIFTloc_j,SIFTdes_j] = vl_sift(single(rgb2gray(image_j)), 'edgethresh', edge_thresh) ;
SIFTloc_j = SIFTloc_j([2,1],:);

%{
[SIFTloc_i,SIFTdes_i] = up_sift(single(rgb2gray(image_i))) ;
SIFTloc_i = SIFTloc_i([2,1],:);
[SIFTloc_j,SIFTdes_j] = up_sift(single(rgb2gray(image_j))) ;
SIFTloc_j = SIFTloc_j([2,1],:);
%}

%% SIFT matching
 
%[matchPointsID_i, matchPointsID_j] = matchSIFTdesImages(SIFTdes_i, SIFTdes_j);
[matchPointsID_i, matchPointsID_j] = matchSIFTdesImagesBidirectional(SIFTdes_i, SIFTdes_j);

minNeighboringFrame = 3;
minNeighboringMatching = 20;

if abs(frameID_i-frameID_j)<=minNeighboringFrame
    if length(matchPointsID_i)<minNeighboringMatching
        fprintf('frame %d + %d: too few matching (%d) => relax SIFT threhsold to 0.7 ', frameID_i, frameID_j , length(matchPointsID_i));
        [matchPointsID_i, matchPointsID_j] = matchSIFTdesImagesBidirectional(SIFTdes_i, SIFTdes_j, 0.7^2);
        if length(matchPointsID_i)<minNeighboringMatching
            fprintf('with %d matching => relax SIFT threhsold to 0.8 ', length(matchPointsID_i));
            [matchPointsID_i, matchPointsID_j] = matchSIFTdesImagesBidirectional(SIFTdes_i, SIFTdes_j, 0.8^2);
            if length(matchPointsID_i)<minNeighboringMatching
                fprintf('with %d matching => relax SIFT threhsold to 0.9 ', length(matchPointsID_i));
                [matchPointsID_i, matchPointsID_j] = matchSIFTdesImagesBidirectional(SIFTdes_i, SIFTdes_j, 0.9^2);
                if length(matchPointsID_i)<minNeighboringMatching
                    fprintf('with %d matching => relax SIFT threhsold to 0.95 ', length(matchPointsID_i));
                    [matchPointsID_i, matchPointsID_j] = matchSIFTdesImagesBidirectional(SIFTdes_i, SIFTdes_j, 0.95^2);
                end
            end
        end
        fprintf('with %d matching \n', length(matchPointsID_i));
    end
end

SIFTloc_i = SIFTloc_i([2 1],matchPointsID_i);
SIFTloc_j = SIFTloc_j([2 1],matchPointsID_j);

% translate to center and invert the vertical
SIFTloc_i(1,:) = -(SIFTloc_i(1,:) - size(image_i,2)/2);
SIFTloc_i(2,:) = -(SIFTloc_i(2,:) - size(image_i,1)/2);

SIFTloc_j(1,:) = -(SIFTloc_j(1,:) - size(image_j,2)/2);
SIFTloc_j(2,:) = -(SIFTloc_j(2,:) - size(image_j,1)/2);



pair.matches = [SIFTloc_i;SIFTloc_j];

%{
figure
imshow(image_i);
hold on
plot(size(image_i,2)/2-SIFTloc_i(1,:),size(image_i,1)/2-SIFTloc_i(2,:),'r+');
figure
imshow(image_j);
hold on
plot(size(image_j,2)/2-SIFTloc_j(1,:),size(image_j,1)/2-SIFTloc_j(2,:),'r+');
%}



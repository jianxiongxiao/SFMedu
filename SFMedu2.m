clc;
disp('SFMedu: Structrue From Motion for Education Purpose');
disp('Version 2 @ 2014');
disp('Written by Jianxiong Xiao (MIT License)');


%% set up things
clear;
close all;
addpath(genpath('matchSIFT'));
addpath(genpath('denseMatch'));
addpath(genpath('RtToolbox'));

visualize = false;

%% data


frames.images{1}='images/B21.jpg';
frames.images{2}='images/B22.jpg';
frames.images{3}='images/B23.jpg';
frames.images{4}='images/B24.jpg';
frames.images{5}='images/B25.jpg';


%{
frames.images{1}='images/kermit000.jpg';
frames.images{2}='images/kermit001.jpg';
frames.images{3}='images/kermit002.jpg';
%}

%{
frames.images{1} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.15.54.jpg';
frames.images{2} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.15.59.jpg';
frames.images{3} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.02.jpg';
frames.images{4} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.05.jpg';
frames.images{5} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.09.jpg';
frames.images{6} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.16.jpg';
frames.images{7} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.20.jpg';
frames.images{8} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.23.jpg';
frames.images{9} ='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.26.jpg';
frames.images{10}='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.29.jpg';
frames.images{11}='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.33.jpg';
frames.images{12}='/Users/xj/Dropbox/Camera Uploads/2014-09-03 14.16.36.jpg';
%}


%% data 
frames.length = length(frames.images);

try
    frames.focal_length = extractFocalFromEXIF(frames.images{1});
catch
end
if ~isfield(frames,'focal_length') || isempty(frames.focal_length)
    fprintf('Warning: cannot find the focal length from the EXIF\n');
    frames.focal_length = 719.5459; % for testing with the B??.jpg sequences
end


maxSize = 1024;
frames.imsize = size(imread(frames.images{1}));
if max(frames.imsize)>maxSize
    scale = maxSize/max(frames.imsize);
    frames.focal_length = frames.focal_length * scale;
    frames.imsize = size(imresize(imread(frames.images{1}),scale));
end


frames.K = f2K(frames.focal_length);
disp('intrinsics:');
disp(frames.K);

%% SIFT matching and Fundamental Matrix Estimation
for frame=1:frames.length-1    
    % need to set this random seed to produce exact same result
    s = RandStream('mcg16807','Seed',10); 
    RandStream.setGlobalStream(s);
    
    % keypoint matching
    %pair = match2viewSURF(frames, frame, frame+1);
    pair = match2viewSIFT(frames, frame, frame+1);
    
    if visualize, showMatches(pair,frames); title('raw feature matching'); end
    
    if true % choose between different ways of getting E
        % Estimate Fundamental matrix
        pair = estimateF(pair);    
        % Convert Fundamental Matrix to Essential Matrix
        pair.E = frames.K' * pair.F * frames.K; % MVG Page 257 Equation 9.12
    else
        % Estimate Essential Matrix directly using 5-point algorithm
        pair = estimateE(pair,frames); 
    end
    

    if visualize, showMatches(pair,frames); title('inliers'); end

    % Get Poses from Essential Matrix
    pair.Rt = RtFromE(pair,frames);
    
    % Convert the pair into the BA format
    Graph{frame} = pair2graph(pair,frames);
    
    % re-triangulation
    Graph{frame} = triangulate(Graph{frame},frames);
    if visualize, visualizeGraph(Graph{frame},frames); title('triangulation'); end
    
    % outlier rejection
    % Graph{frame} = removeOutlierPts(Graph{frame});
    
    % bundle adjustment
    Graph{frame} = bundleAdjustment(Graph{frame});
    if visualize, visualizeGraph(Graph{frame},frames); title('after two-view bundle adjustment'); end
end


%% merge the graphs
%close all
fprintf('\n\nmerging graphs....\n');

mergedGraph = Graph{1};

for frame=2:frames.length-1
    % merge graph
    mergedGraph = merge2graphs(mergedGraph,Graph{frame});
    
    % re-triangulation
    mergedGraph = triangulate(mergedGraph,frames);
    if visualize, visualizeGraph(mergedGraph,frames); title('triangulation'); end
    
    % outlier rejection
    % mergedGraph = removeOutlierPts(mergedGraph,10);
    
    % bundle adjustment
    mergedGraph = bundleAdjustment(mergedGraph);
    
    % outlier rejection
    mergedGraph = removeOutlierPts(mergedGraph, 10);
    
    % bundle adjustment
    mergedGraph = bundleAdjustment(mergedGraph);    
    
    if visualize, visualizeGraph(mergedGraph,frames); title('after bundle adjustment'); end
end

%{
% outlier rejection
mergedGraph = removeOutlierPts(mergedGraph);

% bundle adjustment
mergedGraph = bundleAdjustment(mergedGraph);
if visualize, visualizeGraph(mergedGraph,frames); title('after bundle adjustment'); end

% bundle adjustment with focal length changes
mergedGraph = bundleAdjustment(mergedGraph,true);
if visualize, visualizeGraph(mergedGraph,frames); title('after bundle adjustment with focal length'); end
%}

%printReprojectionError(mergedGraph); % [for homework]

%visualizeReprojection(mergedGraph,frames); % [for homework]

points2ply('sparse.ply',mergedGraph.Str);

if frames.focal_length ~= mergedGraph.f
    disp('Focal length is adjusted by bundle adjustment');
    frames.focal_length = mergedGraph.f;
    frames.K = f2K(frames.focal_length);
    disp(frames.K);
end


%% dense matching

fprintf('dense matching ...\n');
for frame=1:frames.length-1
    Graph{frame} = denseMatch(Graph{frame}, frames, frame, frame+1);
end


%% dense reconstruction
fprintf('triangulating dense points ...\n');
for frame=1:frames.length-1
    clear X;
    P{1} = frames.K * mergedGraph.Mot(:,:,frame);
    P{2} = frames.K * mergedGraph.Mot(:,:,frame+1);
    %par
    for j=1:size(Graph{frame}.denseMatch,2)
        X(:,j) = vgg_X_from_xP_nonlin(reshape(Graph{frame}.denseMatch(1:4,j),2,2),P,repmat([frames.imsize(2);frames.imsize(1)],1,2));
    end
    X = X(1:3,:) ./ X([4 4 4],:);
    x1= P{1} * [X; ones(1,size(X,2))];
    x2= P{2} * [X; ones(1,size(X,2))];
    x1 = x1(1:2,:) ./ x1([3 3],:);
    x2 = x2(1:2,:) ./ x2([3 3],:);
    Graph{frame}.denseX = X;
    Graph{frame}.denseRepError = sum(([x1; x2] - Graph{frame}.denseMatch(1:4,:)).^2,1);
    
    Rt1 = mergedGraph.Mot(:, :, frame);
    Rt2 = mergedGraph.Mot(:, :, frame+1);
    C1 = - Rt1(1:3, 1:3)' * Rt1(:, 4);
    C2 = - Rt2(1:3, 1:3)' * Rt2(:, 4);
    view_dirs_1 = bsxfun(@minus, X, C1);
    view_dirs_2 = bsxfun(@minus, X, C2);
    view_dirs_1 = bsxfun(@times, view_dirs_1, 1 ./ sqrt(sum(view_dirs_1 .* view_dirs_1)));
    view_dirs_2 = bsxfun(@times, view_dirs_2, 1 ./ sqrt(sum(view_dirs_2 .* view_dirs_2)));
    Graph{frame}.cos_angles = sum(view_dirs_1 .* view_dirs_2);
    
    c_dir1 = Rt1(3, 1:3)';
    c_dir2 = Rt2(3, 1:3)';
    Graph{frame}.visible = (sum(bsxfun(@times, view_dirs_1, c_dir1)) > 0) & (sum(bsxfun(@times, view_dirs_2, c_dir2)) > 0);
end

% visualize the dense point cloud
if visualize
    figure
    for frame=1:frames.length-1
        hold on
        goodPoint =  Graph{frame}.denseRepError < 0.05;
        plot3(Graph{frame}.denseX(1,goodPoint),Graph{frame}.denseX(2,goodPoint),Graph{frame}.denseX(3,goodPoint),'.b','Markersize',1);
    end
    hold on
    plot3(mergedGraph.Str(1,:),mergedGraph.Str(2,:),mergedGraph.Str(3,:),'.r')
    axis equal
    title('dense cloud')
    for i=1:frames.length
        drawCamera(mergedGraph.Mot(:,:,i), frames.imsize(2), frames.imsize(1), frames.K(1,1), 0.001,i*2-1);
    end
    axis tight
end

% output as ply file to open in Meshlab (Open Software available at http://meshlab.sourceforge.net )
plyPoint = [];
plyColor = [];
for frame=1:frames.length-1
    goodPoint =  (Graph{frame}.denseRepError < 0.05) & (Graph{frame}.cos_angles < cos(5 / 180 * pi)) & Graph{frame}.visible;
    X = Graph{frame}.denseX(:,goodPoint);
    % get the color of the point
    P{1} = frames.K * mergedGraph.Mot(:,:,frame);
    x1= P{1} * [X; ones(1,size(X,2))];
    x1 = round(x1(1:2,:) ./ x1([3 3],:));
    x1(1,:) = frames.imsize(2)/2 - x1(1,:);
    x1(2,:) = frames.imsize(1)/2 - x1(2,:);
    indlin = sub2ind(frames.imsize(1:2),x1(2,:),x1(1,:));
    im = imresize(imread(frames.images{frame}),frames.imsize(1:2));
    imR = im(:,:,1);
    imG = im(:,:,2);
    imB = im(:,:,3);
    colorR = imR(indlin);
    colorG = imG(indlin);
    colorB = imB(indlin);
    plyPoint = [plyPoint X];
    plyColor = [plyColor [colorR; colorG; colorB]];
end

points2ply('dense.ply',plyPoint,plyColor);

fprintf('SFMedu is finished.\n Open the result dense.ply in Meshlab (Open Software available at http://meshlab.sourceforge.net ).\n Enjoy!\n');


function [matchPointsID_i, matchPointsID_j] = matchSIFTdesImagesBidirectional(X_i, X_j, distRatio)

% SFMedu: Structrue From Motion for Education Purpose
% Written by Jianxiong Xiao (MIT License)


if ~exist('distRatio','var')
    distRatio = 0.6^2;
end

X_i = single(X_i);
X_j = single(X_j);

kdtree_j = vl_kdtreebuild(X_j);
kdtree_i = vl_kdtreebuild(X_i);

numi = size(X_i,2);
matchPointsID_j = zeros(1,numi);
for i = 1 : numi
    [min_idx_j, min_val_j] = vl_kdtreequery(kdtree_j, X_j, X_i(:,i), 'NumNeighbors', 2);
    if (min_val_j(1) < distRatio * min_val_j(2))
        %matchPointsID_j(i) = min_idx_j(1);
        
        [min_idx_i, min_val_i] = vl_kdtreequery(kdtree_i, X_i, X_j(:,min_idx_j(1)), 'NumNeighbors', 2);
        if min_idx_i(1) == i&&  min_val_i(1) < distRatio * min_val_i(2)
            matchPointsID_j(i) = min_idx_j(1);
        end
    end
end

valid = (matchPointsID_j~=0);

pointsID_i = 1:numi;
matchPointsID_i = pointsID_i(valid);
matchPointsID_j = matchPointsID_j(valid);



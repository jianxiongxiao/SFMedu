function pair = estimateE(pair,frames)

t = .002;  % Distance threshold for deciding outliers
[E, inliers] = ransac5point(pair.matches(1:2,:), pair.matches(3:4,:), t, frames.K, 1);


fprintf('%d inliers / %d SIFT matches = %.2f%%\n', length(inliers), size(pair.matches,2), 100*length(inliers)/size(pair.matches,2));
pair.matches = pair.matches(:,inliers);
pair.E = E;
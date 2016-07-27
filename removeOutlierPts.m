function graph=removeOutlierPts(graph,threshold_in_pixels)

if exist('threshold_in_pixels','var')
    threshold_in_pixels = threshold_in_pixels^2;
else
    threshold_in_pixels = 10^2; % square it so that we don't need to square root everytime
end

threshold_in_degree = 2;
threshold_in_cos = cos(threshold_in_degree / 180 * pi);

for c=1:size(graph.ObsIdx,1)
    X = f2K(graph.f) * transformPtsByRt(graph.Str,graph.Mot(:,:,c));
    xy = X(1:2,:) ./ X([3 3],:);
    selector = find(graph.ObsIdx(c,:)~=0);
    
    diff = xy(:,selector) - graph.ObsVal(:,graph.ObsIdx(c,selector));
    
    outliers = sum(diff.^2,1) > threshold_in_pixels;
    
    if sum(outliers)>0
        fprintf('remove %d outliers outof %d points with reprojection error bigger than %f pixels\n',sum(outliers),length(outliers), sqrt(threshold_in_pixels));
    end

    pts2keep = true(1,size(graph.Str,2));
    
    pts2keep(selector(outliers)) = false;
    
    graph.Str = graph.Str(:,pts2keep);

    graph.ObsIdx = graph.ObsIdx(:,pts2keep);
    
end

% return

% Check viewing angle

num_frames = numel(graph.frames);
positions = zeros(3, num_frames);

for ii = 1:num_frames
  Rt = graph.Mot(:, :, ii);
  positions(:, ii) = - Rt(1:3, 1:3)' * Rt(:, 4);
end

view_dirs = zeros(3, size(graph.Str, 2), num_frames);

for c = 1:size(graph.ObsIdx, 1)
  selector = find(graph.ObsIdx(c,:)~=0);
  camera_view_dirs = bsxfun(@minus, graph.Str(:, selector), positions(:, c));
  dir_length = sqrt(sum(camera_view_dirs .* camera_view_dirs));
  camera_view_dirs = bsxfun(@times, camera_view_dirs, 1 ./ dir_length);
  view_dirs(:, selector, c) = camera_view_dirs;
end

for c1 = 1:size(graph.ObsIdx, 1)
  for c2 = 1:size(graph.ObsIdx, 1)
    if c1 == c2
      continue
    end
    selector = find(graph.ObsIdx(c1,:)~=0 & graph.ObsIdx(c2,:)~= 0);
    view_dirs_1 = view_dirs(:, selector, c1);
    view_dirs_2 = view_dirs(:, selector, c2);
    cos_angles = sum(view_dirs_1 .* view_dirs_2);
    outliers = cos_angles > threshold_in_cos;
    
    if sum(outliers)>0
        fprintf('remove %d outliers outof %d points with view angle less than %f degrees\n',sum(outliers),length(outliers), threshold_in_degree);
    end

    pts2keep = true(1,size(graph.Str,2));
    pts2keep(selector(outliers)) = false;
    graph.Str = graph.Str(:,pts2keep);
    graph.ObsIdx = graph.ObsIdx(:,pts2keep);
  end
end

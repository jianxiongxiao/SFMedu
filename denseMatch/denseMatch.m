function pair = denseMatch(pair, frames, frameID_i, frameID_j)

% SFMedu: Structrue From Motion for Education Purpose
% Written by Jianxiong Xiao (MIT License)

im1=imresize(imread(frames.images{frameID_i}),frames.imsize(1:2));
im2=imresize(imread(frames.images{frameID_j}),frames.imsize(1:2));


HalfSizePropagate = 2;

%%
im1 = double(im1)/256;
if size(im1,3)==3
    im1 = ( 76 * im1(:,:,1) + 150 * im1(:,:,2) + 30 * im1(:,:,3) ) / 256;
end
matchable_image1 = ReliableArea(im1);
zncc1 = ZNCCpatch_all(im1,HalfSizePropagate);
%%
im2 = double(im2)/256;
if size(im2,3)==3
    im2 = ( 76 * im2(:,:,1) + 150 * im2(:,:,2) + 30 * im2(:,:,3) ) / 256;
end
matchable_image2 = ReliableArea(im2);
zncc2 = ZNCCpatch_all(im2,HalfSizePropagate);

%%

initial_match = round([size(im1,1)/2-pair.matches(2,:)', size(im1,2)/2-pair.matches(1,:)', size(im1,1)/2-pair.matches(4,:)', size(im1,2)/2-pair.matches(3,:)', zeros(size(pair.matches,2),1)]);
HalfSizePropagate = 2;
match_pair= propagate(initial_match, [], [], matchable_image1, matchable_image2, zncc1, zncc2, HalfSizePropagate );


%imshow(im1)
%plot(pair.denseMatch(:,2)' ,pair.denseMatch(:,1)' ,'.')

pair.denseMatch = match_pair;
pair.denseMatch(:,1) = size(im1,1)/2-pair.denseMatch(:,1);
pair.denseMatch(:,2) = size(im1,2)/2-pair.denseMatch(:,2);
pair.denseMatch(:,3) = size(im2,1)/2-pair.denseMatch(:,3);
pair.denseMatch(:,4) = size(im2,2)/2-pair.denseMatch(:,4);

pair.denseMatch = pair.denseMatch';

pair.denseMatch = pair.denseMatch([2 1 4 3 5],:);


%imshow(im1)
%hold on
%plot(pair.denseMatch(1,:) ,pair.denseMatch(2,:),'.')

%{
figure
colorScale = 3;

im1 = im2double(im1)/colorScale;     
lin1= sub2ind(size(im1),match_pair(:,1),match_pair(:,2));
im1(lin1) = im1(lin1)*colorScale;

im2 = im2double(im2)/colorScale;
lin2= sub2ind(size(im2),match_pair(:,3),match_pair(:,4));
im2(lin2) = im2(lin2)*colorScale;

imMatch = [im1 im2];
imshow(imMatch);
%}
function showMatches(pair,frames)

image_i=imresize(imread(frames.images{pair.frames(1)}),frames.imsize(1:2));
image_j=imresize(imread(frames.images{pair.frames(2)}),frames.imsize(1:2));

figure
imshow(image_i);
hold on
plot(size(image_i,2)/2-pair.matches(1,:),size(image_i,1)/2-pair.matches(2,:),'r+');
figure
imshow(image_j);
hold on
plot(size(image_j,2)/2-pair.matches(3,:),size(image_j,1)/2-pair.matches(4,:),'r+');

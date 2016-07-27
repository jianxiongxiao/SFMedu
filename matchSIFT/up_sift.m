function [F,D] = up_sift(I)
% function that make sift orientation alwasy up

F = vl_sift(I,'PeakThresh',0,'edgethresh',30);

sel = F(4,:)<-pi;

F(4,sel) = F(4,sel) + 2*pi;

sel = F(4,:)>0;

F(4,sel) = - F(4,sel);

%[F,D] = vl_sift(I,'Frames',F);
[F,D] = vl_sift(I,'Frames',F);


%{
figure
imshow(I/255);
hold on
h1 = vl_plotframe(F);

%}
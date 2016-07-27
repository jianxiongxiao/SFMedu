function Rtbest=RtFromE(pair,frames)

% Decompose Essential Matrix
[R1, R2, t1, t2] = PoseEMat(pair.E); % MVG Page 257-259

% Four possible solution
Rt(:,:,1) =[R1 t1];
Rt(:,:,2) =[R1 t2];
Rt(:,:,3) =[R2 t1];
Rt(:,:,4) =[R2 t2];

% triangulation 
P{1} = frames.K * [eye(3) [0;0;0]];

goodCnt = zeros(1,4);
for i=1:4
    clear X;
    P{2} = frames.K * Rt(:,:,i);
    for j=1:size(pair.matches,2)
        X(:,j) = vgg_X_from_xP_nonlin(reshape(pair.matches(:,j),2,2),P,repmat([frames.imsize(2);frames.imsize(1)],1,2));
    end
    X = X(1:3,:) ./ X([4 4 4],:);

    dprd = Rt(3,1:3,i) * ((X(:,:) - repmat(Rt(1:3,4,i),1,size(X,2))));
    goodCnt(i) = sum(X(3,:)>0 & dprd > 0);

end


% pick one solution from the four
fprintf('%d\t%d\t%d\t%d\n',goodCnt);
[~, bestIndex]=max(goodCnt);

Rtbest = Rt(:,:,bestIndex);
    

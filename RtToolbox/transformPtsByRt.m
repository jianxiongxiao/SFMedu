function Y3D = transformPtsByRt(X3D, Rt, isInverse)

if nargin<3 || ~isInverse
    Y3D = Rt(:,1:3) * X3D + repmat(Rt(:,4),1,size(X3D,2));
else
    Y3D = Rt(:,1:3)' * (X3D - repmat(Rt(:,4),1,size(X3D,2)));
end

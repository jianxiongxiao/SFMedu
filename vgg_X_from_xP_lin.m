%vgg_X_from_xP_lin  Estimation of 3D point from image matches and camera matrices, linear.
%   X = vgg_X_from_xP_lin(x,P,imsize) computes projective 3D point X (column 4-vector)
%   from its projections in K images x (2-by-K matrix) and camera matrices P (K-cell
%   of 3-by-4 matrices). Image sizes imsize (2-by-K matrix) are needed for preconditioning.
%   By minimizing algebraic distance.
%
%   See also vgg_X_from_xP_nonlin.

% werner@robots.ox.ac.uk, 2003

function X = vgg_X_from_xP_lin(u,P,imsize)

if iscell(P)
  P = cat(3,P{:});
end
K = size(P,3);

if nargin>2
  for k = 1:K
    H = [2/imsize(1,k) 0 -1
         0 2/imsize(2,k) -1
         0 0              1];
    P(:,:,k) = H*P(:,:,k);
    u(:,k) = H(1:2,1:2)*u(:,k) + H(1:2,3);
  end
end

A = [];
for k = 1:K
  A = [A; vgg_contreps([u(:,k);1])*P(:,:,k)];
end
% A = normx(A')';
[dummy,dummy,X] = svd(A,0);
X = X(:,end);

% Get orientation right
s = reshape(P(3,:,:),[4 K])'*X;
if any(s<0)
  X = -X;
  if any(s>0)
%    warning('Inconsistent orientation of point match');
  end
end

return

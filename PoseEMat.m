% PoseEMat - estimate the pose from essential matrix with SVD.
%
% Usage:    
%           [R1, R2, t1, t2] = PoseEMat(E)
%
% Input:
%           E   : essential matrix
%
% Output:
%           R1  : 3x3 rotation matrix 1
%           R2  : 3x3 rotation matrix 2
%           t1   : 3x1 translation vector 1
%           t2   : 3x1 translation vector 2
%
% This code follows the algorithm given by 
% [1] Hartley and Zisserman "Multiple View Geometry in Computer Vision,"
%     pp.257-259, 2003.
%
% Kim, Daesik
% Intelligent Systems Research Center
% Sungkyunkwan Univ. (SKKU), South Korea
% E-mail  : daesik80@skku.edu
% Homepage: http://www.daesik80.com
%
% June 2008  - Original version.
% Check determinant, 2014 by Fisher Yu

function [R1, R2, t1, t2] = PoseEMat(E)

%% essential matrix decomposition
[U,D,V] = svd(E);

%disp('D')
%disp(D)

W = [0 -1 0; 1 0 0; 0 0 1];
Z = [0  1 0;-1 0 0; 0 0 0];

%% translaton vector (skew-symmetry matrix)
S = U*Z*U';

%% two possible rotation matrices
R1 = U*W*V';
R2 = U*W'*V';

%% two possible translation vectors
t1 = U(:,3);
t2 = -U(:,3);

%% check determinant

if det(R1) < 0
  R1 = -R1;
end

if det(R2) < 0
  R2 = -R2;
end
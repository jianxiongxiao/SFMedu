function A=xprodmat(a)
%Matrix representation of a cross product
%
% A=xprodmat(a)
%
%in:
%
% a: 3D vector
%
%out:
%
% A: a matrix such that A*b=cross(a,b)


if length(a)<3, error 'Input must be a vector of length 3'; end

ax=a(1);
ay=a(2);
az=a(3);

A=zeros(3);

A(2,1)=az;  A(1,2)=-az;
A(3,1)=-ay; A(1,3)=ay;
A(3,2)=ax;  A(2,3)=-ax;

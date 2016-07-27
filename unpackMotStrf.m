function [Mot,Str,f] = unpackMotStrf(nCam,vec)

if mod(length(vec),3)==0
    cut = 3*2*nCam;
    Mot = reshape(vec(1:cut),3,2,[]);
    Str = reshape(vec(cut+1:end),3,[]);    
else
    cut = 1+3*2*nCam;
    f   = vec(1);
    Mot = reshape(vec(2:cut),3,2,[]);
    Str = reshape(vec(cut+1:end),3,[]);
end
function residuals = reprojectionResidual(ObsIdx,ObsVal,px,py,f,Mot,Str)

% (Constant) ObsIdx: index of KxN for N points observed by K cameras, sparse matrix
% (Constant) ObsVal: 2xM for M observations
% px,py: princple points in pixels
% f: focal length in pixels
% Mot: 3x2xK for K cameras
% Str: 3xN for N points


nCam = size(ObsIdx,1);

if nargin==5
    [Mot,Str,f] = unpackMotStrf(nCam,f);
elseif nargin==6
    [Mot,Str]   = unpackMotStrf(nCam,Mot);
end

Mot = reshape(Mot,3,2,[]);
Str = reshape(Str,3,[]);

residuals = [];
for c=1:nCam
    validPts = ObsIdx(c,:)~=0;
    validIdx = ObsIdx(c,validPts);
    
    RP = AngleAxisRotatePts(Mot(:,1,c), Str(:,validPts));
    
    TRX = RP(1,:) + Mot(1,2,c);
    TRY = RP(2,:) + Mot(2,2,c);
    TRZ = RP(3,:) + Mot(3,2,c);
    
    TRXoZ = TRX./TRZ;
    TRYoZ = TRY./TRZ;
    
    x = f*TRXoZ + px;
    y = f*TRYoZ + py;
    
    ox = ObsVal(1,validIdx);
    oy = ObsVal(2,validIdx);
    
    residuals = [residuals [x-ox; y-oy]];    
end

residuals = residuals(:);

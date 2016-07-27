function graph = bundleAdjustment(graph, adjustFocalLength)

% convert from Rt matrix to AngleAxis
nCam=length(graph.frames);
Mot = zeros(3,2,nCam);
for camera=1:nCam
    Mot(:,1,camera) = RotationMatrix2AngleAxis(graph.Mot(:,1:3,camera));
    Mot(:,2,camera) = graph.Mot(:,4,camera);
end



Str = graph.Str;
f  = graph.f;


% assume px, py=0
px = 0;
py = 0;



residuals = reprojectionResidual(graph.ObsIdx,graph.ObsVal,px,py,f,Mot,Str);
fprintf('initial error = %f\n', 2*sqrt(sum(residuals.^2)/length(residuals)));

% bundle adjustment using lsqnonlin in Matlab (Levenberg-Marquardt)
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');

% adjust structure [for homework]
% !!! fill in your code here
%fprintf('error = %f\n', 2*sqrt(resnorm/length(residuals)));

% adjust motion [for homework]
% !!! fill in your code here
%fprintf('error = %f\n', 2*sqrt(resnorm/length(residuals)));

% adjust motion and structure
[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) reprojectionResidual(graph.ObsIdx,graph.ObsVal,px,py,f,x), [Mot(:); Str(:)],[],[],options);
[Mot,Str] = unpackMotStrf(nCam,vec);
fprintf('error = %f\n', 2*sqrt(resnorm/length(residuals)));


if exist('adjustFocalLength','var') && adjustFocalLength
    % adjust focal length, motion and structure
    [vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) reprojectionResidual(graph.ObsIdx,graph.ObsVal,px,py,x), [f; Mot(:); Str(:)],[],[],options);
    [Mot,Str,f] = unpackMotStrf(nCam,vec);
    fprintf('error = %f\n', resnorm/length(residuals));
    graph.f = f;
end


%residuals = reprojectionResidual(graph.ObsIdx,graph.ObsVal,px,py,f,Mot,Str);
%fprintf('final error = %f\n', 2*sqrt(sum(residuals.^2)/length(residuals)));


for camera=1:nCam
    graph.Mot(:,:,camera) = [AngleAxis2RotationMatrix(Mot(:,1,camera))  Mot(:,2,camera)];    
end
graph.Str = Str;


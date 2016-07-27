function Rt = concatenateRts(RtOuter, RtInner)

% Rt * X = RtOuter * RtInner * X

Rt = [RtOuter(:,1:3)* RtInner(:,1:3)  RtOuter(:,1:3)*RtInner(:,4) + RtOuter(:,4)];

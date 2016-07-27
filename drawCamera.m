function drawCamera(Rt, w, h, f, scale, lineWidth)
% SFMedu: Structrue From Motion for Education Purpose
% Written by Jianxiong Xiao (MIT License)

% Xcamera = Rt * Xworld
V= [...
0 0 0 f -w/2  w/2 w/2 -w/2
0 0 f 0 -h/2 -h/2 h/2  h/2
0 f 0 0  f    f    f   f];

V = V*scale;

V = transformPtsByRt(V, Rt, true);

hold on;
plot3(V(1,[1 4]),V(2,[1 4]),V(3,[1 4]),'-r','LineWidth',lineWidth);
plot3(V(1,[1 3]),V(2,[1 3]),V(3,[1 3]),'-g','LineWidth',lineWidth);
plot3(V(1,[1 2]),V(2,[1 2]),V(3,[1 2]),'-b','LineWidth',lineWidth);

plot3(V(1,[1 5]),V(2,[1 5]),V(3,[1 5]),'-k','LineWidth',lineWidth);
plot3(V(1,[1 6]),V(2,[1 6]),V(3,[1 6]),'-k','LineWidth',lineWidth);
plot3(V(1,[1 7]),V(2,[1 7]),V(3,[1 7]),'-k','LineWidth',lineWidth);
plot3(V(1,[1 8]),V(2,[1 8]),V(3,[1 8]),'-k','LineWidth',lineWidth);

plot3(V(1,[5 6 7 8 5]),V(2,[5 6 7 8 5]),V(3,[5 6 7 8 5]),'-k','LineWidth',lineWidth);

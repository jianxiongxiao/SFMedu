function angle_axis = RotationMatrix2AngleAxis(R)

% The conversion of a rotation matrix to the angle-axis form is
% numerically problematic when then rotation angle is close to zero
% or to Pi. The following implementation detects when these two cases
% occurs and deals with them by taking code paths that are guaranteed
% to not perform division by a small number.

% x = k * 2 * sin(theta), where k is the axis of rotation.
angle_axis(1) = R(1+2, 1+1) - R(1+1, 1+2);
angle_axis(2) = R(1+0, 1+2) - R(1+2, 1+0);
angle_axis(3) = R(1+1, 1+0) - R(1+0, 1+1);


% Since the right hand side may give numbers just above 1.0 or
% below -1.0 leading to atan misbehaving, we threshold.
costheta = min(max((R(1+0, 1+0) + R(1+1, 1+1) + R(1+2, 1+2) - 1.0) / 2.0,  -1.0), 1.0);

% sqrt is guaranteed to give non-negative results, so we only
% threshold above.
sintheta = min(sqrt(angle_axis(1) * angle_axis(1) + angle_axis(2) * angle_axis(2) + angle_axis(3) * angle_axis(3)) / 2.0, 1.0);

% Use the arctan2 to get the right sign on theta
theta = atan2(sintheta, costheta);

% Case 1: sin(theta) is large enough, so dividing by it is not a
% problem. We do not use abs here, because while jets.h imports
% std::abs into the namespace, here in this file, abs resolves to
% the int version of the function, which returns zero always.
%
% We use a threshold much larger then the machine epsilon, because
% if sin(theta) is small, not only do we risk overflow but even if
% that does not occur, just dividing by a small number will result
% in numerical garbage. So we play it safe.
kThreshold = 1e-12;
if ((sintheta > kThreshold) || (sintheta < -kThreshold))
    r = theta / (2.0 * sintheta);
    angle_axis = angle_axis * r;
    return;
end

% Case 2: theta ~ 0, means sin(theta) ~ theta to a good
% approximation.
if (costheta > 0.0)
    angle_axis = angle_axis * 0.5;
    return;
end

% Case 3: theta ~ pi, this is the hard case. Since theta is large,
% and sin(theta) is small. Dividing by theta by sin(theta) will
% either give an overflow or worse still numerically meaningless
% results. Thus we use an alternate more complicated formula
% here.

% Since cos(theta) is negative, division by (1-cos(theta)) cannot
% overflow.
inv_one_minus_costheta = 1.0 / (1.0 - costheta);

% We now compute the absolute value of coordinates of the axis
% vector using the diagonal entries of R. To resolve the sign of
% these entries, we compare the sign of angle_axis[i]*sin(theta)
% with the sign of sin(theta). If they are the same, then
% angle_axis[i] should be positive, otherwise negative.

for i=1:3
    angle_axis(i) = theta * sqrt((R(i, i) - costheta) * inv_one_minus_costheta);
    if (((sintheta < 0.0) && (angle_axis(i) > 0.0)) || ((sintheta > 0.0) && (angle_axis(i) < 0.0)))
        angle_axis(i) = -angle_axis(i);
    end
end

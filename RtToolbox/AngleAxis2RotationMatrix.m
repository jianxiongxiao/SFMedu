function R = AngleAxis2RotationMatrix(angle_axis)

theta2 = dot(angle_axis,angle_axis);
if (theta2 > 0.0)
    % We want to be careful to only evaluate the square root if the
    % norm of the angle_axis vector is greater than zero. Otherwise
    % we get a division by zero.
    
    theta = sqrt(theta2);
    wx = angle_axis(1) / theta;
    wy = angle_axis(2) / theta;
    wz = angle_axis(3) / theta;
    
    costheta = cos(theta);
    sintheta = sin(theta);
    
    R(1+0, 1+0) =     costheta   + wx*wx*(1 -    costheta);
    R(1+1, 1+0) =  wz*sintheta   + wx*wy*(1 -    costheta);
    R(1+2, 1+0) = -wy*sintheta   + wx*wz*(1 -    costheta);
    R(1+0, 1+1) =  wx*wy*(1 - costheta)     - wz*sintheta;
    R(1+1, 1+1) =     costheta   + wy*wy*(1 -    costheta);
    R(1+2, 1+1) =  wx*sintheta   + wy*wz*(1 -    costheta);
    R(1+0, 1+2) =  wy*sintheta   + wx*wz*(1 -    costheta);
    R(1+1, 1+2) = -wx*sintheta   + wy*wz*(1 -    costheta);
    R(1+2, 1+2) =     costheta   + wz*wz*(1 -    costheta);
else
    % At zero, we switch to using the first order Taylor expansion.
    R(1+0, 1+0) =  1;
    R(1+1, 1+0) = -angle_axis(3);
    R(1+2, 1+0) =  angle_axis(2);
    R(1+0, 1+1) =  angle_axis(3);
    R(1+1, 1+1) =  1;
    R(1+2, 1+1) = -angle_axis(1);
    R(1+0, 1+2) = -angle_axis(2);
    R(1+1, 1+2) =  angle_axis(1);
    R(1+2, 1+2) = 1;
end

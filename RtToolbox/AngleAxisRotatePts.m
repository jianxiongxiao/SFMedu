function result = AngleAxisRotatePts(angle_axis, pt)

angle_axis = reshape(angle_axis(1:3),1,3);

theta2 = dot(angle_axis,angle_axis);

if (theta2 > 0.0)
    % Away from zero, use the rodriguez formula
    %
    %   result = pt costheta + (w x pt) * sintheta + w (w . pt) (1 - costheta)
    %
    % We want to be careful to only evaluate the square root if the
    % norm of the angle_axis vector is greater than zero. Otherwise
    % we get a division by zero.
    
    theta = sqrt(theta2);
    w = angle_axis / theta;
    
    costheta = cos(theta);
    sintheta = sin(theta);
    
    % w_cross_pt = cross(w, pt);
    w_cross_pt = xprodmat(w) * pt;
    
    %w_dot_pt = dot(w, pt);
    w_dot_pt = w * pt;
    
    result = pt * costheta + w_cross_pt * sintheta + (w' * (1 - costheta)) * w_dot_pt;
    
    
else
    % Near zero, the first order Taylor approximation of the rotation
    % matrix R corresponding to a vector w and angle w is
    %
    %   R = I + hat(w) * sin(theta)
    %
    % But sintheta ~ theta and theta * w = angle_axis, which gives us
    %
    %  R = I + hat(w)
    %
    % and actually performing multiplication with the point pt, gives us
    % R * pt = pt + w x pt.
    %
    % Switching to the Taylor expansion at zero helps avoid all sorts
    % of numerical nastiness.
    
    %w_cross_pt = cross(angle_axis, pt);
    w_cross_pt = xprodmat(angle_axis) * pt; % vectorize version
    
    result = pt + w_cross_pt;
    
end

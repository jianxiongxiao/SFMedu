function [E, inliers] = ransac5point(x1, x2, t, K, feedback)

	% written by Fisher Yu @ 2014

    if ~all(size(x1)==size(x2))
        error('Data sets x1 and x2 must have the same dimension');
    end
    
    if nargin == 4
	feedback = 0;
    end
    
    [rows,npts] = size(x1);
    if rows~=2 && rows~=3
        error('x1 and x2 must have 2 or 3 rows');
    end
    
    if rows == 2    % Pad data with homogeneous scale factor of 1
        x1 = [x1; ones(1,npts)];
        x2 = [x2; ones(1,npts)];        
    end
    
    K_inv = inv(K);
    
    x1 = K_inv * x1;
    x2 = K_inv * x2;

    s = 5;  % Number of points needed to fit a fundamental matrix. Note that
            % only 7 are needed but the function 'fundmatrix' only
            % implements the 8-point solution.
    
    fittingfn = @fit5point;
    distfn    = @funddist;
    degenfn   = @isdegenerate;
    % x1 and x2 are 'stacked' to create a 6xN array for ransac
    [E, inliers] = ransac([x1; x2], fittingfn, distfn, degenfn, s, t, feedback);
    
end
    
    
function Es = fit5point(x)

E = peig5pt(x(1:3, :), x(4:6, :));

num_solutions = size(E, 1) / 3;
Es = cell(num_solutions, 1);

for ii = 1:num_solutions
  Ei = E((ii*3-2):(ii*3), :);
  Ei = Ei ./ Ei(3,3);
  Es{ii} = Ei;
end

end
    
%--------------------------------------------------------------------------
% Function to evaluate the first order approximation of the geometric error
% (Sampson distance) of the fit of a fundamental matrix with respect to a
% set of matched points as needed by RANSAC.  See: Hartley and Zisserman,
% 'Multiple View Geometry in Computer Vision', page 270.
%
% Note that this code allows for F being a cell array of fundamental matrices of
% which we have to pick the best one. (A 7 point solution can return up to 3
% solutions)

function [bestInliers, bestF] = funddist(F, x, t)
    
    x1 = x(1:3,:);    % Extract x1 and x2 from x
    x2 = x(4:6,:);
    
    
    if iscell(F)  % We have several solutions each of which must be tested
		  
	nF = length(F);   % Number of solutions to test
	bestF = F{1};     % Initial allocation of best solution
	ninliers = 0;     % Number of inliers
	
	for k = 1:nF
	    x2tFx1 = zeros(1,length(x1));
	    for n = 1:length(x1)
		x2tFx1(n) = x2(:,n)'*F{k}*x1(:,n);
	    end
	    
	    Fx1 = F{k}*x1;
	    Ftx2 = F{k}'*x2;     

	    % Evaluate distances
	    d =  x2tFx1.^2 ./ ...
		 (Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2);
	    
	    inliers = find(abs(d) < t);     % Indices of inlying points
	    
	    if length(inliers) > ninliers   % Record best solution
		ninliers = length(inliers);
		bestF = F{k};
		bestInliers = inliers;
	    end
	end
    
    else     % We just have one solution
	x2tFx1 = zeros(1,length(x1));
	for n = 1:length(x1)
	    x2tFx1(n) = x2(:,n)'*F*x1(:,n);
	end
	
	Fx1 = F*x1;
	Ftx2 = F'*x2;     
	
	% Evaluate distances
	d =  x2tFx1.^2 ./ ...
	     (Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2);
	
	bestInliers = find(abs(d) < t);     % Indices of inlying points
	bestF = F;                          % Copy F directly to bestF
	
    end
    
end
	


%----------------------------------------------------------------------
% (Degenerate!) function to determine if a set of matched points will result
% in a degeneracy in the calculation of a fundamental matrix as needed by
% RANSAC.  This function assumes this cannot happen...
     
function r = isdegenerate(x)
    r = 0;    
end
    

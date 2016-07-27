function varargout = phow(varargin)
% VL_PHOW  Extract PHOW features
%   [FRAMES, DESCRS] = VL_PHOW(IM) extracts PHOW features from the
%   image IM. This function is a wrapper around VL_DSIFT() and
%   VL_IMSMOOTH().
%
%   The PHOW descriptors where introduced in [1]. By default,
%   VL_PHOW() computes the gray-scale variant of the descriptor.  The
%   COLOR option can be used to compute the color variant instead.
%
%   Verbose:: [false]
%     Set to true to turn on verbose output.
%
%   Sizes:: [[4 6 8 10]]
%     Scales at which the dense SIFT features are extracted. Each
%     value is used as bin size for the VL_DSIFT() function.
%
%   Fast:: [true]
%     Set to false to turn off the fast SIFT features computation by
%     VL_DSIFT().
%
%   Step:: [2]
%     Step (in pixels) of the grid at which the dense SIFT features
%     are extracted.
%
%   Color:: [GRAY]
%     Choose between GRAY (PHOW-gray), RGB, HSV, and OPPONENT
%     (PHOW-color).
%
%   ContrastThreshold:: [0.005]
%     Contrast threshold below which SIFT features are mapped to
%     zero. The input image is scaled to have intensity range in [0,1]
%     (rather than [0,255]) and this value is compared to the
%     descriptor norm as returned by VL_DSIFT().
%
%   WindowSize:: [1.5]
%     Size of the Gaussian window in units of spatial bins.
%
%   Magnif:: [6]
%     The image is smoothed by a Gaussian kernel of standard deviation
%     SIZE / MAGNIF.
%
%   FloatDescriptors:: [false]
%     If set to TRUE, the descriptors are returned in floating point
%     format.
%
%   See also: VL_DSIFT(), VL_HELP().
[varargout{1:nargout}] = vl_phow(varargin{:});

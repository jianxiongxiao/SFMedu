function varargout = plotframe(varargin)
% VL_PLOTFRAME  Plot feature frame
%  VL_PLOTFRAME(FRAME) plots the frames FRAME.  Frames are attributed
%  image regions (as, for example, extracted by a feature detector). A
%  frame is a vector of D=2,3,..,6 real numbers, depending on its
%  class. VL_PLOTFRAME() supports the following classes:
%
%   * POINTS
%     + FRAME(1:2)   coordinates
%
%   * CIRCLES
%     + FRAME(1:2)   center
%     + FRAME(3)     radius
%
%   * ORIENTED CIRCLES
%     + FRAME(1:2)   center
%     + FRAME(3)     radius
%     + FRAME(4)     orientation
%
%   * ELLIPSES
%     + FRAME(1:2)   center
%     + FRAME(3:5)   S11, S12, S22 such that ELLIPSE = {x: x' inv(S) x = 1}.
%
%   * ORIENTED ELLIPSES
%     + FRAME(1:2)   center
%     + FRAME(3:6)   stacking of A such that ELLIPSE = {A x : |x| = 1}
%
%  H=VL_PLOTFRAME(...) returns the handle of the graphical object
%  representing the frames.
%
%  VL_PLOTFRAME(FRAMES) where FRAMES is a matrix whose column are FRAME
%  vectors plots all frames simultaneously. Using this call is much
%  faster than calling VL_PLOTFRAME() for each frame.
%
%  VL_PLOTFRAME(FRAMES,...) passes any extra argument to the underlying
%  plot function. The first optional argument can be a line
%  specification string such as the one used by PLOT().
%
%  See also: VL_HELP().
[varargout{1:nargout}] = vl_plotframe(varargin{:});

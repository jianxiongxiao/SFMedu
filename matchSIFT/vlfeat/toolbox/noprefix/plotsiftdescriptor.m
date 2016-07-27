function varargout = plotsiftdescriptor(varargin)
% VL_PLOTSIFTDESCRIPTOR   Plot SIFT descriptor
%   VL_PLOTSIFTDESCRIPTOR(D) plots the SIFT descriptors D, stored as
%   columns of the matrix D. D has the same format used by VL_SIFT().
%
%   VL_PLOTSIFTDESCRIPTOR(D,F) plots the SIFT descriptors warped to
%   the SIFT frames F, specified as columns of the matrix F. F has the
%   same format used by VL_SIFT().
%
%   H=VL_PLOTSIFTDESCRIPTOR(...) returns the handle H to the line drawing
%   representing the descriptors.
%
%   REMARK. By default, the function assumes descriptors with 4x4
%   spatial bins and 8 orientation bins (Lowe's default.)
%
%   The function supports the following options
%
%   NumSpatialBins:: [4]
%     Number of spatial bins in each spatial direction.
%
%   NumOrientBins:: [8]
%     Number of orientation bis.
%
%   Magnif:: [3]
%     Magnification factor.
%
%   See also: VL_SIFT(), VL_PLOTFRAME(), VL_HELP().
[varargout{1:nargout}] = vl_plotsiftdescriptor(varargin{:});

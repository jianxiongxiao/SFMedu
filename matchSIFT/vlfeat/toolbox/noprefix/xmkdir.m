function varargout = xmkdir(varargin)
% VL_XMKDIR  Create a directory recursively.
%   VL_XMKDIR(PATH) creates all directory specified by PATH if they
%   do not exist (existing directories are skipped).
%
%   The function accepts the following options:
%
%   Pretend:: [false]
%     Set to true to avoid creating any directory but print which
%     directories would be created (implies 'Verbose',true).
%
%   Verbose:: [false]
%     Set to true to print the operations performed.
%
%   See also: VL_HELP().
[varargout{1:nargout}] = vl_xmkdir(varargin{:});

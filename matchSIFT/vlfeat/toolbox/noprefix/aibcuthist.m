function varargout = aibcuthist(varargin)
% VL_AIBCUTHIST  Compute histogram over VL_AIB cut
%  HIST = VL_AIBCUTHIST(MAP, X) computes the histogram of the data X over
%  the specified VL_AIB cut MAP (as returned by VL_AIBCUT()).  Each element
%  of HIST counts how many elements of X are projected in the
%  corresponding cut node.
%
%  Data are mapped to bins as specified by VL_AIBCUTPUSH(). Data mapped
%  to the null node are dropped.
%
%  VL_AIBCUTHIST() accepts the following options:
%
%  Nulls:: [drop]
%    What to do of null nodes: drop ('drop'), accumulate to an
%    extra bin at the end of HIST ('append'), or accumulate to
%    the first bin ('first')
%
%  See also: VL_AIB(), VL_HELP().
[varargout{1:nargout}] = vl_aibcuthist(varargin{:});

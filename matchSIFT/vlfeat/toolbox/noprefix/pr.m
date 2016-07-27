function varargout = pr(varargin)
% VL_PR Compute precision-recall curve
%  [RECALL, PRECISION] = VL_PR(LABELS, SCORES) computes the
%  precision-recall (PR) curve. LABELS are the ground thruth labels
%  (+1 or -1) and SCORES are the scores associated to them by a
%  classifier (lager scores correspond to positive guesses).
%
%  RECALL and PRECISION are the recall and the precision for
%  increasing values of the decision threshold.
%
%  Set the zero the lables of data points to ignore in the evaluation.
%
%  Set to -INF the score of data points which are never retrieved. In
%  this case the PR curve will have maximum recall < 1.
%
%  VL_PR() accepts the following options:
%
%  InludeInf:: [false]
%    If set to true, data with -INF score is included in the
%    evaluation and the maximum recall is 1 even if -INF scores are
%    present.
%
%  Stable:: [false]
%    If set to true, RECALL and PRECISION are in the samre order of
%    LABELS and SCORES rather than being sorted by increasing
%    RECALL. This option implies INCLUDEINF.
%
%  About the PR curve::
%    This section uses the same symbols used in the documentation of
%    the VL_ROC() function. In addition to those quantities, define:
%
%      PRECISION(S) = TP(S) / (TP(S) + FP(S))
%      RECALL(S) = TP(S) / P = TPR(S)
%
%    The precision is the fraction of positivie predictions which are
%    correct, and the recall is the fraction of positive labels that
%    have been correctly classified (recalled). Notice that the
%    recall is also equal to the true positive rate for the ROC curve
%    (see VL_ROC()).
%
%  Remark::
%    Precision (P) is undefined for those values of the
%    classifier threshold for which no example is classified as
%    positive. Conventionally, a precision of P=1 is assigned to such
%    cases.
%
%  See also: VL_ROC(), VL_HELP().
[varargout{1:nargout}] = vl_pr(varargin{:});

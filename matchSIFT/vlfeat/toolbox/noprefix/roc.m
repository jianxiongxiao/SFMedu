function varargout = roc(varargin)
% VL_ROC Compute ROC curve
%  [TP,TN] = VL_ROC(LABELS, SCORES) computes the receiver operating
%  characteristic (ROC curve). LABELS are the ground thruth labels (+1
%  or -1) and SCORE is the scores assigned to them by a classifier
%  (higher scores correspond to positive labels).
%
%  [TP,TN] are the true positive and true negative rates for
%  incereasing values of the decision threshold.
%
%  Set the zero the lables of samples to ignore in the evaluation.
%
%  Set to -INF the score of samples which are never retrieved. In
%  this case the PR curve will have maximum recall < 1.
%
%  [TP,TN,INFO] = VL_ROC(...) returns the following additional
%  information:
%
%  INFO.EER:: Equal error rate.
%  INFO.AUC:: Area under the VL_ROC (AUC).
%  INFO.UR::  Uniform prior best op point rate.
%  INFO.UT::  Uniform prior best op point threhsold.
%  INFO.NR::  Natural prior best op point rate.
%  INFO.NT::  Natural prior best op point threshold.
%
%  VL_ROC(...) with no output arguments plots the VL_ROC diagram in
%  the current axis.
%
%  About the ROC curve::
%    Consider a classifier that predicts as positive all lables Y
%    whose SCORE is not smaller than a threshold S. The ROC curve
%    represents the performance of such classifier as the threshold S
%    is changed. Define
%
%      P = num. of positive samples,
%      N = num. of negative samples,
%
%    and for each threshold S
%
%      TP(S) = num. of samples that are correctly classified as positive,
%      TN(S) = num. of samples that are correctly classified as negative,
%      FP(S) = num. of samples that are incorrectly classified as positive,
%      FN(S) = num. of samples that are incorrectly classified as negative.
%
%    Consider also the rates:
%
%      TPR = TP(S) / P,      FNR = FN(S) / P,
%      TNR = TN(S) / N,      FPR = FP(S) / N,
%
%    and notice that by definition
%
%      P = TP(S) + FN(S) ,    N = TN(S) + FP(S),
%      1 = TPR(S) + FNR(S),   1 = TNR(S) + FPR(S).
%
%    The ROC curve is the parametric curve (TPR(S), TNR(S)) obtained
%    as the classifier threshold S is varied from -INF to +INF. The
%    TPR is also known as recall (see VL_PR()).
%
%    The ROC curve is contained in the square with vertices (0,0) The
%    (average) ROC curve of a random classifier is a line which
%    connects (1,0) and (0,1).
%
%    The ROC curve is independent of the prior probability of the
%    labels (i.e. of P/(P+N) and N/(P+N)).
%
%    An OPERATING POINT is a point on the ROC curve corresponding to
%    a certain threshold S. Each operating point corresponds to
%    minimizing the empirical 01 error of the classifier for given
%    prior probabilty of the labels. VL_ROC() computes the following
%    operating points:
%
%     Natural operating point:: Assumes P[Y=+1] = P / (P + N).
%     Uniform operating point:: Assumes P[Y=+1] = 1/2.
%
%   VL_ROC() acccepts the following options:
%
%   Plot:: []
%     Setting this option turns on plotting. Set to 'TrueNegative' or
%     'TN' to plot TP(S) (recall) vs. TN(S). Set to 'FalseNegative' or
%     'FN' to plot TP(S) (recall) vs. FP(S) = 1 - TN(S).
%
%  See also: VL_PR(), VL_HELP().
[varargout{1:nargout}] = vl_roc(varargin{:});

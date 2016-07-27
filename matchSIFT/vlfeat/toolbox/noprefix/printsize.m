function varargout = printsize(varargin)
% VL_PRINTSIZE  Set the print size of a figure
%   VL_PRINTSIZE(R) sets the PaperPosition property of the current
%   figure so that the width of the figure is the fraction R of a
%   'uslsetter' page. It also sets the PaperSize property to tightly
%   match the figure size. In this way, printing to any format crops
%   the figure similar to what printing to EPS would do.
%
%   VL_PRINTSIZE(FIG,R) opearates on the specified figure FIG.
%
%   This command is useful to resize a figure before printing it so
%   that elements are scaled appropriately to match the desired figure
%   size in print. The function accepts the following optional
%   arguments:
%
%   Aspect:: [none]
%     Change the figure aspect ratio (widht/height) to the specified
%     value.
%
%   Reference:: [vertical]
%     If set to 'horizontal' the ratio R is the widht of the figure
%     over the width of the page. If 'vertical', the ratio R is the
%     height of the figure over the height of the page.
%
%   PaperType:: [letter]
%     Set the type (size) of the reference paperReference. Any of the
%     paper types supported by MATLAB can be used (see PRINT())).
%
%   See also: VL_HELP().
[varargout{1:nargout}] = vl_printsize(varargin{:});

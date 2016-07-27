% PQ_TOP queries for the topmost element of the priority queue (not removing it)
%
% SYNTAX
% [idx, cost] = pq_top(pq)
%
% INPUT PARAMETERS
%   pq: a pointer to the priority queue
%
% OUTPUT PARAMETERS
%   idx: the index of the topmost element
%   cost: the cost of the topmost element
% 
% DESCRIPTION
% Queries the topmost element from a priority queue returning its 
% index and associated cost.
%  
% See also:
% PQ_DEMO, PQ_CREATE, PQ_PUSH, PQ_POP, PQ_SIZE, PQ_TOP, PQ_DELETE
%
% References:
% Gormen, T.H. and Leiserson, C.E. and Rivest, R.L., "introduction to
% algorithms", 1990, MIT Press/McGraw-Hill, Chapter 6. 

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: andrea.tagliasacchi@gmail.com
% $Revision: 1.0$  Created on: May 22, 2009
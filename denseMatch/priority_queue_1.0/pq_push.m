% PQ_PUSH inserts a new element/update a cost in the priority queue
%
% SYNTAX
% pq_push(pq, idx, cost)
%
% INPUT PARAMETERS
%   pq: a pointer to the priority queue
%
% OUTPUT PARAMETERS
%   idx:  the index of the element
%   cost: the cost of the newly inserted element or the 
%         cost to which the element should be updated to
% 
% DESCRIPTION
% Inserts a new element in the priority queue. If the elements already 
% exist (elements identified by their "idx"), its cost is updated and a new
% element will not be inserted.
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
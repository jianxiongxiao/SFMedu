% PQ_SIZE returns the number of elements in the priority queue
%
% SYNTAX
% sz = pq_size(pq)
%
% INPUT PARAMETERS
%   pq: a pointer to the priority queue
%
% OUTPUT PARAMETERS
%   sz:  the number of elements in the priority queue
% 
% DESCRIPTION
% Queries the priority queue for the number of elements that it contains.
% This number is not the "capacity" or the maximum number of elements which
% is possible to insert but rather the number of elements CURRENTLY in the
% priority queue
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
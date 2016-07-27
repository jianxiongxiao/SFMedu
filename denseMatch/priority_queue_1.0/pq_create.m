% PQ_CREATE construct a priority queue object
%
% SYNTAX
% pq = pq_create(p)
%
% INPUT PARAMETERS
%   N: the maximum number of elements in the priority queue
%
% OUTPUT PARAMETERS
%   pq: a (memory) pointer to the created data structure
%
% DESCRIPTION
% Given a positive integer N this function allocates the memory for a 
% BACK INDEXED priority queue of size N. The priority queue is a Max Heap, 
% meaninig that it is implemented as a binary tree and parent nodes have a
% cost which is larger than the one of its childrens. Back indexing allows
% to be able to *increase* the cost of an element which is already in the
% priority queue and do so in logarithmic time.
% 
% The complexity of the operations on the data structure are the default
% ones for Heap based priority queue:
% 
% - insertion: O(log(n))
% - pop: O(log(n))
% - cost update: O(log(n))
% - size: O(1)
% - query top: O(1)
% - delete: O(n)
% 
% See also:
% PQ_DEMO, PQ_PUSH, PQ_POP, PQ_SIZE, PQ_TOP, PQ_DELETE
%
% References:
% Gormen, T.H. and Leiserson, C.E. and Rivest, R.L., "introduction to
% algorithms", 1990, MIT Press/McGraw-Hill, Chapter 6. 

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: andrea.tagliasacchi@gmail.com
% $Revision: 1.0$  Created on: May 22, 2009
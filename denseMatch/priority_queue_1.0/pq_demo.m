% PQ_DEMO compiles library and illustrate Priority Queue's functionalities
%
% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: andrea.tagliasacchi@gmail.com
% $Revision: 1.0$  Created on: May 22, 2009

clc, clear, close all;
mex pq_create.cpp; 
mex pq_push.cpp; 
mex pq_pop.cpp; 
mex pq_size.cpp; 
mex pq_top.cpp;
mex pq_delete.cpp;
pq = pq_create( 10000 ); 

for i=1:10
    disp(sprintf('\n')); %newline

    %--- create a random entry
    cost = rand(1);
    pq_push(pq, i, cost);
    disp(sprintf('inserted element: [%d,%f]', i, cost ));

    %--- query for the new head
    [idx,cost] = pq_top(pq);
    newsize = pq_size(pq);
    disp(sprintf('*** |queue| = %d, TOP=[%d,%f]', newsize, idx, cost ));

    %--- randomly pop an element
    if rand(1)>.5
        disp(sprintf('\n'));
        disp(sprintf('random pop!'));
        [idx,cost] = pq_pop(pq);
        newsize = pq_size(pq);
        disp(sprintf('*** |queue| = %d, POPPED=[%d,%f]', newsize, idx, cost ));
    end
end
pq_delete(pq);
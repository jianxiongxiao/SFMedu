//==============================================================================
// Name        : pq_pop.cpp
// Author      : Andrea Tagliasacchi
// Version     : 1.0
// Copyright   : 2009 (c) Andrea Tagliasacchi
// Description : pops an element from the PQ and returns its index and cost
//
// May 22, 2009: Created
//==============================================================================

#include "MyHeap.h"

//------------------------------- MATLAB -------------------------------------//
#ifdef MATLAB_MEX_FILE
#include "mex.h"
#define toSysout(...) printf(__VA_ARGS__)
 #define exit_with_error(...)           \
 do {                                   \
		 fprintf(stdout, "Error: ");    \
		 fprintf(stdout, __VA_ARGS__ ); \
		 fprintf(stdout, "\n" );        \
		 exit(1);                       \
 } while(0)


void retrieve_heap( const mxArray* matptr, MaxHeap<double>* & heap){
    // retrieve pointer from the MX form
    double* pointer0 = mxGetPr(matptr);
    // check that I actually received something
    if( pointer0 == NULL )
        mexErrMsgTxt("vararg{1} must be a valid priority queue pointer\n");
    // convert it to "long" datatype (good for addresses)
    long pointer1 = (long) pointer0[0];
    // convert it to "KDTree"
    heap = (MaxHeap<double>*) pointer1;
    // check that I actually received something
    if( heap == NULL )
        mexErrMsgTxt("vararg{1} must be a valid priority queue pointer\n");
}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	if( nrhs!=1 )
		mexErrMsgTxt("This function requires 3 arguments\n");
	if( !mxIsNumeric(prhs[0]) )
		mexErrMsgTxt("parameter 1 missing!\n");

	// retrieve the heap
	MaxHeap<double>*  heap;
	retrieve_heap( prhs[0], heap);


	// extract head before popping
	pair<double, int> curr = heap->top();
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*mxGetPr(plhs[0]) = curr.second+1;
	plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*mxGetPr(plhs[1]) = curr.first;

	// pop top element in the PQ
	heap->pop();
}
#endif

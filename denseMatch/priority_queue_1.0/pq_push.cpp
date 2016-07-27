//==============================================================================
// Name        : pq_push.cpp
// Author      : Andrea Tagliasacchi
// Version     : 1.0
// Copyright   : 2009 (c) Andrea Tagliasacchi
// Description : inserts a new element in the priority queue
//
// May 22, 2009: Created
//==============================================================================

#include "MyHeap.h"

//------------------------------- MATLAB -------------------------------------//
 #define toSysout(...) printf(__VA_ARGS__)
 #define exit_with_error(...)           \
 do {                                   \
		 fprintf(stdout, "Error: ");    \
		 fprintf(stdout, __VA_ARGS__ ); \
		 fprintf(stdout, "\n" );        \
		 exit(1);                       \
 } while(0)
#ifdef MATLAB_MEX_FILE
#include "mex.h"

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
void retrieve_index( const mxArray* matptr, int& index){
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("missing second parameter (element index)\n");

	if( 1 != mxGetM(matptr) || !mxIsNumeric(matptr) || 1 != mxGetN(matptr) )
		mexErrMsgTxt("second parameter should be a unique integer array index\n");

	// retrieve index
	index = (int) mxGetScalar(matptr);

	if( index % 1 != 0 )
		mexErrMsgTxt("the index should have been an integer!\n");
}
void retrieve_cost( const mxArray* matptr, double& cost){
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("missing third parameter (element index)\n");

	if( 1 != mxGetM(matptr) || !mxIsNumeric(matptr) || 1 != mxGetN(matptr) )
		mexErrMsgTxt("second parameter should be a unique integer array index\n");

	// retrieve index
	cost = (double) mxGetScalar(matptr);
}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	if( nrhs!=3 )
		mexErrMsgTxt("This function requires 3 arguments\n");
	if( !mxIsNumeric(prhs[0]) )
		mexErrMsgTxt("parameter 1 missing!\n");
	if( !mxIsNumeric(prhs[1]) )
		mexErrMsgTxt("parameter 2 missing!\n");
	if( !mxIsNumeric(prhs[2]) )
		mexErrMsgTxt("parameter 3 missing!\n");


	// retrieve the heap
	MaxHeap<double>*  heap;
	retrieve_heap( prhs[0], heap);
	// retrieve the parameters
	int index;
	retrieve_index( prhs[1], index );
	double cost;
	retrieve_cost( prhs[2], cost);

	// push in the PQ
	heap->push( cost, index-1 );

	// return control to matlab
	return;
}
#endif

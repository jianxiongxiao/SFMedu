//==============================================================================
// Name        : myheaps_demo.cpp
// Author      : Andrea Tagliasacchi
// Version     : 1.0
// Copyright   : 2009 (c) Andrea Tagliasacchi
// Description : creates a (top-down) priority queue
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

void retrieve_data( const mxArray* prhs, int& nelems){
    // retrieve pointer from the MX form
    // check that I actually received something
//    if( data == NULL )
//        mexErrMsgTxt("vararg{2} must be a [kxN] matrix of data\n");

    nelems = (int) mxGetScalar(prhs);
    if( nelems == 0 )
    	mexErrMsgTxt("Priority queue minimal allocation is 1.\n");

}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	// read the parameters
	// check input
	if( nrhs != 1 || !mxIsNumeric(prhs[0]) )
		mexErrMsgTxt("A unique scalar number with the expected size of the queue is necessary.\n");

	// retrieve the data
	int nelems = 100;
	retrieve_data( prhs[0], nelems );

	// instantiate the priority queue
	MaxHeap<double>* pq = new MaxHeap<double>(nelems);

	// convert the points to double
	plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
	double* pointer_to_tree = mxGetPr(plhs[0]);
	pointer_to_tree[0] = (long) pq;
}
#endif

#include "MyHeap.h"
#include <stdlib.h>
#include <cmath>
#include <iostream>
#include <algorithm>
using namespace std;

/// TEST FOR MAXHEAP
int test1(){
	MaxHeap<double> pq(7); // heap of ints compared by doubles

	pq.push( 1,1 );
	pq.push( 6,0 );
	pq.push( 2,4 );
	pq.push( 3,3 );
	pq.push( 4,2 );
	pq.push( 5,5 );
	// test the updates
	pq.push( 6,5 );
	pq.push( 3,7 );

	// check ordering
	while( !pq.empty() ){
		cout << "[ " << pq.top().second << " " << pq.top().first << " ] " << endl;
		pq.pop();
	}
	return 0;
}
/// Indexing test, check whether tree indexes are behaving properly. A bug here caused a long headache...
int test2(){
	cout << "0:" << endl;
	cout << PARENT(0) << endl;
	cout << LEFT(0) << endl;
	cout << RIGHT(0) << endl << endl;

	cout << "1:" << endl;
	cout << PARENT(1) << endl;
	cout << LEFT(1) << endl;
	cout << RIGHT(1) << endl << endl;

	cout << "2:" << endl;
	cout << PARENT(2) << endl;
	cout << LEFT(2) << endl;
	cout << RIGHT(2) << endl << endl;

	cout << "3:" << endl;
	cout << PARENT(3) << endl;
	cout << LEFT(3) << endl;
	cout << RIGHT(3) << endl << endl;

	cout << "7:" << endl;
	cout << PARENT(7) << endl;
	cout << LEFT(7) << endl;
	cout << RIGHT(7) << endl << endl;

	return 0;
}
/// EXTENSIVE (RANDOM) TEST OF PUSH/POP
int test3(){
	int N = 100000;
	MaxHeap<double> pq(N); // heap of ints compared by doubles
	for (int n=0; n < N; n++) {
		// create random push and updates
		double key = float(rand()) / RAND_MAX;
		pq.push( key, n );
		//Verify at each step O(n)
		//if( pq.verifyHeap() == false ){
		//	cout << "error on pusching of " << n << endl;
		//	exit(0);
		//}
	}

	// verify that exhaustive pop is done in decreasing
	double prev_max = 1; // since we provide keys [0,1)
	while( !pq.empty() ){
		pair<double, int> curr = pq.top();
		if( curr.first > prev_max ){
			cout << "BUG: " << curr.first << " > " << prev_max << endl;
			exit(0);
		} else {
			prev_max = curr.first;
		}
		pq.pop();
	}

	cout << "terminated correctly" << endl;
	exit(0);
}
/// MAXHEAP EXTENSIVE (RANDOM) TEST OF RANDOM ACCESS UPDATE
int test4(){
	// create base queue
	int N = 100000;
	MaxHeap<double> pq(N); // heap of ints compared by doubles
	vector<double> costs(N); // cache costs
	for (int n=0; n < N; n++) {
		// create random push and updates
		double key = float(rand()) / RAND_MAX;
		costs[ n ] = key;
		pq.push( key, n );
	}

	// create random updated (increase in value) to random elements
	for (int n=0; n < N; n++) {
		// create random push and updates
		int index = rand() % N;
		double keyupdate = ( float(rand()) / RAND_MAX ) / 50; // small update
		costs[index] += keyupdate;
		pq.push( costs[index], index );
	}

	// verify that exhaustive pop is done in decreasing
	double prev_max = 2; // since we provide keys [0,1)
	while( !pq.empty() ){
		pair<double, int> curr = pq.top();
		if( curr.first > prev_max ){
			cout << "BUG: " << curr.first << " > " << prev_max << endl;
			exit(0);
		} else {
			prev_max = curr.first;
		}
		pq.pop();
	}

	cout << "terminated correctly" << endl;
	exit(0);
}
/// MINHEAP EXTENSIVE (RANDOM) TEST OF RANDOM ACCESS UPDATE
int test5(){
	// create base queue
	int N = 100000;
	MinHeap<double> pq(N); // heap of ints compared by doubles
	vector<double> costs(N); // cache costs
	for (int n=0; n < N; n++) {
		// create random push and updates
		double key = float(rand()) / RAND_MAX;
		costs[ n ] = key;
		pq.push( key, n );
	}

	// create random updated (increase in value) to random elements
	for (int n=0; n < N; n++) {
		// create random push and updates
		int index = rand() % N;
		double keyupdate = ( float(rand()) / RAND_MAX ) / 50; // small update
		costs[index] -= keyupdate;
		pq.push( costs[index], index );
	}

	// verify that exhaustive pop is done in decreasing
	double prev_min = -2; // since we provide keys [0,1)
	while( !pq.empty() ){
		pair<double, int> curr = pq.top();
		if( curr.first < prev_min ){
			cout << "BUG: " << curr.first << " < " << prev_min << endl;
			exit(0);
		} else {
			prev_min = curr.first;
		}
		pq.pop();
	}

	cout << "terminated correctly" << endl;
	exit(0);
}
/// FULL HEAP SORT + MATLAB-STYLE BACKINDEXES
int test6(){
	int N = 10;
	MinHeap<double> heap(N);
	vector<double>  data(N);
	for (int n=0; n < N; n++) {
		double key = round( (float(rand()) / RAND_MAX)*10 );
		data.push_back(key);
		heap.push( key, n  );
	}

	heap.print();

	// sort back indexes
	vector<int> indexes;
	indexes.reserve(10);
	heap.heapsort( indexes );

	// output sorted element indexes
	for( int n=0; n<N; n++)
		cout << indexes[n] << " ";

	return 0;
}
/// MINHEAP: HEAP SORT & BACKINDEXES (KD-TREE related test)
int test7(){
	// MULTIMEDIAN (KD-TREE)
	int N = 10;
	MinHeap<double> heap_x(N);
	MinHeap<double> heap_y(N);
	MinHeap<double> heap_z(N);
	vector< vector<double> > data(N, vector<double>(3,0));
	vector<double>  idxs_x(N);
	vector<double>  idxs_y(N);
	vector<double>  idxs_z(N);

	for (int n=0; n < N; n++) {
		double key_x = round( (float(rand()) / RAND_MAX)*10 );
		double key_y = round( (float(rand()) / RAND_MAX)*10 );
		double key_z = round( (float(rand()) / RAND_MAX)*10 );
		data[n][0] = key_x;
		data[n][1] = key_y;
		data[n][2] = key_z;
		// fill the heaps
		heap_x.push( key_x, n );
		heap_y.push( key_y, n );
		heap_z.push( key_z, n );
	}

	// print out original points
	cout << "data" << endl;
	for( int n=0; n<N; n++)
		cout << n << "  ";
	cout << endl << "---------------------------" << endl;
	for( int n=0; n<N; n++)
		cout << data[n][0] << "  ";
	cout << endl;
	for( int n=0; n<N; n++)
		cout << data[n][1] << "  ";
	cout << endl;
	for( int n=0; n<N; n++)
		cout << data[n][2] << "  ";
	cout << endl << endl;

	vector< vector<int> > indexes( 3, vector<int>(N,0) ); //back indexes
	heap_x.heapsort( indexes[0] );
	heap_y.heapsort( indexes[1] );
	heap_z.heapsort( indexes[2] );

	//indexes from data offset to position in sortex k-th dimension
	cout << "back indexes" << endl;
	for( int n=0; n<N; n++)
		cout << indexes[0][n] << " ";
	cout << endl;
	for( int n=0; n<N; n++)
		cout << indexes[1][n] << " ";
	cout << endl;
	for( int n=0; n<N; n++)
		cout << indexes[2][n] << " ";

	return 0;
}
/// MINHEAP: No backindexed heap structure, just test push/pop. Used in kNN kd-trees
int test8(){
	// create random inserts
	int N = 100000;


	MinHeap<double> pq;    // heap of ints key-ed by double
	for (int n=0; n < N; n++) {
		// create random push and updates
		double key = double(rand()) / RAND_MAX;
		pq.push( key, n );
	}

	// verify that exhaustive pop is done in decreasing
	double prev_min = -2; // since rand provide keys [0,1)
	while( !pq.empty() ){
		pair<double, int> curr = pq.top();
		if( curr.first < prev_min ){
			cout << "BUG: " << curr.first << " < " << prev_min << endl;
			exit(1);
		}
		else
			prev_min = curr.first;

		pq.pop();
	}

	return 0;
}

//class CMP{
//	public double k;
//	public int    i;
//};

bool comp(const int &a, const int &b){
	return a>b;
}
int test9(){
	int a[8] = {1,2,3,4,5,6,7,8};
	vector<int> v1(a, a+8);

	// use one of the following
	std::make_heap(v1.begin(), v1.end(), comp );
	std::sort_heap(v1.begin (), v1.end (), comp );
	for (unsigned int i=0; i < v1.size(); ++i)
		cout << v1[i] << " ";
	cout << endl;
	return 0;
}
int test10(){
	int a[7] = {1,2,3,4,5,6,7};
	vector<int> v(a, a+7);
	vector<int> larray(4);
	vector<int> rarray(3);
	std::copy(v.begin(), v.end()-v.size()/2, larray.begin());
	std::copy(v.end()-v.size()/2, v.end(), rarray.begin());

    for (int i=0; i < v.size(); ++i)
		cout << v[i] << " ";
	cout << endl;
    for (int i=0; i < larray.size(); ++i)
		cout << larray[i] << " ";
	cout << endl;
    for (int i=0; i < rarray.size(); ++i)
		cout << rarray[i] << " ";
	cout << endl;
	return 0;
}

////////////// MAIN //////////////
int main(int argc, char **argv) {
//	test1();
//	test2();
//	test3();
//	test4();
//	test5();
//	test6();
//	test7();
//	test8();
//	test9();
	test10();
}

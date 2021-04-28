#include <stdio.h>
 
 
__global__ void helloGPU( char *str ) {
 
  printf( "Hello %s from GPU thread %d in block %d\n", str, threadIdx.x, blockIdx.x );
 
}
 
 
int main(int argc, char *argv[]) {

  const int N = 8;
  const int csize = N*sizeof(char);
  const int no_blocks = 4;
  const int no_threads = 5;
  char str[8];
  char *gstr;

  scanf("%s", str);

  cudaMalloc( (void**)&gstr, csize );
  cudaMemcpy( gstr, str, csize, cudaMemcpyHostToDevice );

  helloGPU<<<no_blocks,no_threads>>>( gstr ); 
  cudaDeviceSynchronize();
 
  cudaFree( gstr );
  return 0;
}

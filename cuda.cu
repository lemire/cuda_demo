#include <stdio.h>
#define SIZE 20
__global__ void VectorAdd(int *a, int *b, int *c, int n) {
  int i = threadIdx.x;
  if (i < n)
    c[i] = a[i] + b[i];
}

int main() {

  int *a, *b, *c;
  int *h_a, *h_b, *h_c; /*declare pointers to host arrays*/

  cudaMalloc((void **)&a, SIZE * sizeof(int));
  cudaMalloc((void **)&b, SIZE * sizeof(int));
  cudaMalloc((void **)&c, SIZE * sizeof(int));

  /* allocate memory for host arrays */
  h_a = new int[SIZE];
  h_b = new int[SIZE];
  h_c = new int[SIZE];

  /* initialize values on host arrays */
  for (int i = 0; i < SIZE; i++) {
    h_a[i] = i;
    h_b[i] = i;
  }

  /*copy data from host to device */
  cudaMemcpy(a, h_a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(b, h_b, SIZE * sizeof(int), cudaMemcpyHostToDevice);

  VectorAdd<<<1, SIZE>>>(a, b, c, SIZE);
  // cudaDeviceSynchronize(); /* this is not needed because cudaMemcpy implies
  // sync. */

  /*copy results from device to host*/
  cudaMemcpy(h_c, c, SIZE * sizeof(int), cudaMemcpyDeviceToHost);

  for (int i = 0; i < SIZE; i++) {
    printf("%d \n", h_c[i]);
  }

  cudaFree(a);
  cudaFree(b);
  cudaFree(c);

  /* free host memory */
  delete[] h_a;
  delete[] h_b;
  delete[] h_c;

  return 0;
}

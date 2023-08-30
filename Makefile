cuda : cuda.cu
	/usr/local/cuda/bin/nvcc -o cuda cuda.cu 
clean:
	rm -r -f cuda

rm -rf ./bin/*;

nvcc -g ./kernel.cu -o ./bin/kernel;

./bin/kernel;
#include <stdint.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#include <string>

#include <iostream>

#include <atomic>

#include <mutex>
#include <vector>

#define maxiterations 100


//Cuda functions
__device__ int8_t get_iterations(double a1, double b1){
    int8_t iterations = 0;
    double a = a1;
    double b = b1;
    while(a*a + b*b < 4 && iterations < maxiterations){
        double a_new = a*a - b*b + a1;
        double b_new = 2*a*b + b1;
        a = a_new;
        b = b_new;
        iterations++;
    }
    return iterations;
}

__device__ ulong3 hueToRGB(int hue) {
    // hue is an integer between 0 and 360
    // this function converts it to an RGB color
    // the output is a 3-element array of integers between 0 and 255
    ulong3 rgb;
    int h = hue;
    if (h < 60) {
        rgb.x = 255;
        rgb.y = h * 255 / 60;
        rgb.z = 0;
    } else if (h < 120) {
        rgb.x = 255 - (h - 60) * 255 / 60;
        rgb.y = 255;
        rgb.z = 0;
    } else if (h < 180) {
        rgb.x = 0;
        rgb.y = 255;
        rgb.z = (h - 120) * 255 / 60;
    } else if (h < 240) {
        rgb.x = 0;
        rgb.y = 255 - (h - 180) * 255 / 60;
        rgb.z = 255;
    } else if (h < 300) {
        rgb.x = (h - 240) * 255 / 60;
        rgb.y = 0;
        rgb.z = 255;
    } else {
        rgb.x = 255;
        rgb.y = 0;
        rgb.z = 255 - (h - 300) * 255 / 60;
    }
    return rgb;
}

__global__ void stuffKernel(ulong3 *arrayPtr, dim3 dimensions, dim3 threadAreaSize)
{
    for(int x = 0; x < threadAreaSize.x; x++){
        for(int y = 0; y < threadAreaSize.y; y++){
            double a = (threadIdx.x + x / threadAreaSize.x) / dimensions.x * 4 - 2;
            double b = (threadIdx.y + y / threadAreaSize.y) / dimensions.y * 4 - 2;
            int8_t iterations = get_iterations(a, b);
            ulong3 color = {0, 0, 0};
            if(iterations < maxiterations){
                color = hueToRGB((iterations % 10) / 10 * 360);
            }

            arrayPtr[(threadIdx.y * threadAreaSize.y + y) * 1080 + threadIdx.x * threadAreaSize.x + x] = color;

        }
    }

}

//Cpu functions
int main()

{
    //set Cuda Device
    cudaDeviceReset();
    cudaError_t cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        return 1;
    }
    else {
        fprintf(stdout, "Successfully set CudaDevice\n");
    }

    //cudaStream_t *mainStream;
    //cudaStreamCreate(mainStream);

    

    int imageWidth = 1080;
    int imageHeight = 1080;

    int long3size = 24;
    //long arrayBytes = imageWidth * imageHeight * long3size;

    fprintf(stdout, "hallo ey");

    ulong3 *arrayPtr;
    cudaMalloc((void **) &arrayPtr, 8 * sizeof(ulong3));

    fprintf(stdout, "hallo eyoo");

    dim3 threads_per_block = dim3(32, 32, 1);
    dim3 blocks_per_grid = dim3(1, 1, 1);
    dim3 dimensions = dim3(threads_per_block.x * blocks_per_grid.x, threads_per_block.y * blocks_per_grid.y, 1);
    dim3 threadAreaSize = dim3(imageWidth/dimensions.x, imageHeight/dimensions.y, 1);

    fprintf(stdout, "Hallovorvor");

    //uint3 arraySize = {imageWidth, imageHeight, 1};

    //stuffKernel<<<blocks_per_grid, threads_per_block, 0, *mainStream>>>(arrayPtr, dimensions, threadAreaSize);

    


    fprintf(stdout, "Hallovor");

    cudaStatus = cudaDeviceSynchronize();

    
    fprintf(stdout, "Hallo");
    
    //cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }

    while (true) {
        
    }

    return 0;
}

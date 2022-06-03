echo "building...";

del "%CD%\bin\kernel.*"

nvcc -ccbin "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.31.31103/bin/Hostx64/x64/cl.exe" -g %CD%/kernel.cu -o %CD%/bin/kernel.exe

echo "running...";
%CD%/bin/kernel.exe;

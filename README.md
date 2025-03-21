# NestedCLKernels
OpenCL experiment with nested kernels.
This app compares two bitmaps, a background (or source bitmap) and a sub-bitmap (or the searched bitmap), to get the coordinates of the sub-bitmap on the background.
Both, the pixel comparison algoritm, and the "coordinates-sliding" algorithm are running on GPU.
The first version is used to reproduce unknown errors and bugs.

dependencies:
https://github.com/VCC02/MiscUtils

.

Compiler: FreePascal (CodeTyphon edition): https://pilotlogic.com/sitejoom/index.php/downloads/category/14-codetyphon.html

How to install and build compiler+IDEs https://pilotlogic.com/sitejoom/index.php/wiki?id=167

The current binaries in this repo are built with CT 8.4.
To manually build the binaries, please sync/clone/download this repo and the MiscUtils repo, at the same directory level, then open the project (.ctpr) file with Typhon32 or Typhon64, then compile / build (/ run). The current .cl code is intended to work on OpenCL v3.0.

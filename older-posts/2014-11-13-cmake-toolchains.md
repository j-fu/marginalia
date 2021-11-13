
# Changing compilers, flags etc. in cmake
(2014-11-10)


CMake does a great job in auto-detecting your system. But
what to do if you want to be in control of the choice
of compilers, flags etc ? Use toolchain files.

<!-- more -->

## Resources

The  start of my cmake thing is [here](2014-10-30-cmake.html).

Please          consider           the          discussion          on
[cross  compiling](http://www.cmake.org/Wiki/CMake_Cross_Compiling) on
the cmake home page. Using this approach I was able to cross-compile
code for Windows (via [mingw](http://www.mingw.org/) on Linux, including
GUI  ([fltk](http://www.fltk.org)) and OpenGL.

## How to work with toolchain files

The basic approach is to split your CMake system into two parts:

- one generic (wrt. system) part which describes your project
- one system  specific part which describes the compiler etc.

For an example, we set up a second version of our project in
[tinyproject2.zip](blobs/tinyproject2.zip) by just adding
one file to it, let us call it `intel.cmake`.

It contains

````
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_COMPILER_VENDOR "intel")

set(CMAKE_C_COMPILER icc)
set(CMAKE_C_FLAGS "-O3 " CACHE STRING "" FORCE)
````

Now, we do the standard out-of-source build thing with one modification:


    $ mkdir build
	$ cd build
	$ cmake -DCMAKE_TOOLCHAIN_FILE=../intel.cmake ..
	$ cd ..
	$ make -C build
	$ .build/hello
	Hello world, the answer is 42!

During  the cmake  run you  should see  that cmake  detects the  intel
compiler and then uses it.

Please note, that due to the out-of-source work flow it is very easy
to work in parallel on different versions, e.g.

    gnu-dbg
	gnu-opt
	intel-dbg
	intel-opt

etc. Each has its own toolchain file and build directory.


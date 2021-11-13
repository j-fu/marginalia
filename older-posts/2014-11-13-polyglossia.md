# Bringing Fortran, C and C++ together

(2014-11-13)

Most compiler suites come today with the (not so) holy trinity
of widespread compiled languages: Fortran, C and C++. Here are
some remarks on using them together.

<!-- more -->

Disclaimer: On  the Fortran side,  this is mostly  about Fortran77/95.
Modern Fortran has more tools for  this. So, this information might be
useful for interfacing legacy code.

## Ways of passing of data  to subroutines

- C:
  C has two options to pass data: by value and by address. Obviously,
  if we want to interface with Fortran, we can us only passing by address
  Thus, we can have

````
void abc(int x) /* by value*/
void abc(int *x) /* by address*/
````


- Fortran:
  Fortran77  passes  all  data  by address,  unless  some
  extensions are used which are not really portable.

````
c      passing a scalar:
       subroutine abc(x)
	   integer x

c      passing an array: 
       subroutine abc(x)
	   integer x
	   dimendsion x(10)
````


- C++ has three options: by value, by address and by reference:

````
void abc(int x) // by value
void abc(int *x) // by address
void abc(int &x) // by reference
````


So, the lowest  common denominator between C,C++ and Fortran  is passing by
address, and the lowest common denominator between C and C++ is passing
by address or by value.

## Name mangling

Linking together  compilation units  from different  languages creates
the  need  to  identify  "linker symbols"  created  by  the  different
languages from the  same name in the source code.  The same name shows
up differently.

The name `abc` is transformed  to

- Fortran: `abc_` (on most unices) or  `ABC_` or `abc` or `ABC`
- C: abc
- C++ `_Z3abci` (by value) or ` _Z3abcRi` (by reference) or
  `_Z3abcPi` (by address)


## How to solve:

- F77 Macro form CMake
- `extern "C"` in C++






@def maxtoclevel=3
@def tags = ["julia"]
@def rss_description = "Julia: Achieving Performance."
@def rss_pubdate = Date(2022, 2, 9)

# Julia: Achieving Performance 
- 2022-02-09: RSS
- 2021-11-15: Initial version

\toc

In  order  to  let  newcomers  to the  language  experience  the  real
performance potential of Julia it  is important to raise the awareness
for the corresponding "tricks" early on.

This text results from an effort  to improve the code performance of a
piece  of experimental  research  code  which has  been  written by  a
colleague new  to Julia. It   describes the steps  taken  to  get runtime
down from 13s to 0.07s and allocations form 763.08 M allocations to 86.


## Other resources on this topic

- It turned out that all necessary information is described on the [Julia performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-tips) page, this text should be understood as an additional explanation from a bit different angle and a bit more in layman's terms.  The corresponding links to the documentation sections are provided.

- Also, the [7 Julia Gotchas](https://www.stochasticlifestyle.com/7-julia-gotchas-handle/) still are worth to read in this context.

- UPDATE 2021-12-01: [Writing type-stable Julia code](https://blog.sintef.com/industry-en/writing-type-stable-julia-code/)

 

##   "Measure performance with @time and pay attention to memory allocations"
[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/performance-tips/#Measure-performance-with-[@time](@ref)-and-pay-attention-to-memory-allocatioan)

One allocation can use the time of several hundred floating point multiplications. 


In order to understand the role of allocations ist is useful to 
understand the concept of [stack and heap](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html#the-stack-and-the-heap),
which is fundamental for any modern computer language (as e.g. for Rust in the previous link).


An allocation reserves memory from the memory pool of the operating system ("heap") and is expensive  as the  interaction  with the  operating  system  kernel needs certain amount of bookkeeping. Fundamentally, an allocation happens in  any language when  creating an object of a priori unknown size, e.g. an  array of length unknown at compile time. Objects with a priori known size, as e.g. structs  can be placed on top of a piece of memory pre-allocated during program start called "stack", with almost no bookkeeping as no allocation from the system is necessary.

In Julia, the  [`@time`](https://docs.julialang.org/en/v1/base/base/#Base.@time) macro can be used to find allocations. Besides the execution time it prints  the number of allocations happening when running  the measured expression.
There is also the possibility to run the code with  [`julia --track-allocation`](https://docs.julialang.org/en/v1/manual/command-line-options/#command-line-options).



The idea is then "hunt" allocations by placing temporary @time statements in critical places of the code. In particular, removing allocations from "hot loops" with will pay off. 



## "REPL based workflow"
[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/workflow-tips/#REPL-based-workflow) 

During code development it is  helpful never to leave the Julia command line and to include the code after each change using the `include` statement.
This approach avoids Just-in-time (JIT) recompilation which is peformed at startup time.

For more intense projects it is worth to use [Revise.jl](https://github.com/timholy/Revise.jl) for automatic handling of code updates instead of calling `include` again and again.

Also it may be worth to have a look at the [Visual Studio Code](https://www.julia-vscode.org/) editing environment for working with Julia.

<!-- ---------------------------------------------------------- --> 
##  "Avoid global variables"

[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-global-variables)

Avoid to work with global variables. E.g. instead of

```julia
a=10
b=11

function important(x)
   x=5*a+b
end

important(10)
```

write

```julia
a=10
b=11

function important(x,a,b)
     x=5*a+b
end
important(10,a,b)

```

A more profound approach which would keep parameter lists  short may be the creation of a context `struct` which collects the parameters.

Alternatively, wrap the global context into a function 
```julia
function run()
  a::Int=10
  b::Int=11

  function important(x)
     x=5*a+b
  end
  important(10)
end
```
and ensure that [`a` and `b` never change type](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-captured)
by [type-annotating](https://docs.julialang.org/en/v1/manual/types/#Type-Declarations) them (which is not possible for global variables).


##### Rationale:
Julia assumes that a global variable can change its type anytime, so it needs to be wrapped  into a container ("boxing") labeled with its current type. Handling these is expensive and manifests itself in additional allocations.
Type changes of captured variables would have similar implications.
In fact, this is very similar to the way e.g. python works with _any_ variable.



## "Pre-allocate outputs"

[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/performance-tips/#Pre-allocating-outputs)

Pre-allocate memory e.g. for arrays needed in inner loops.
In the case where array sizes are unknown a priori,  replace expressions like  `F=[something(i) for i=1:N]`  by 

```julia
function Fnum(F)
  ...
  if length(F)<N
    resize!(F,N)
  end
  for i=1:N 
     F[i]=something(i)
  end
  ...  
end
```
where `F` is initialized e.g. via `F=zeros(0)` is created once and passed to `FNum`. 

  
##### Rationale:

An expression like `F=[...]` creates an array and allocates memory for it. If this happens for a temporay variable used in a function called many times, this becomes a massive performance hit. Therefore, it is better  to pre-allocate this
  memory, pass it to the inner loop function and to  increase it on necessity (leading only to few allocations if the hitherto length was too short).

## "Avoid changing the type of a variable" 

[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-changing-the-type-of-a-variable)


Replace   `x=0`, `x=1`, etc. by `x=0.0`, `x=1.0` etc when it comes to declarations of variables later used as floating point values. 




Another alternative is to [type-annotate](https://docs.julialang.org/en/v1/manual/types/#Type-Declarations) variables when declaring them the first time: `x::FLoat64=1`.

##### Rationale: 

Setting `x=1`, and writing  later `x=2.0` changes the type of `x` and creates a [type instability](https://docs.julialang.org/en/v1/manual/faq/#man-type-stability)
with very much the same consequences as described above with respect to global variables.
The [`@code_warntype`](https://docs.julialang.org/en/v1/manual/performance-tips/#man-code-warntype) macro can help to find corresponding situations.


## "More dots: fuse vectorized operations"

[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/performance-tips/#More-dots:-Fuse-vectorized-operations)

Replace vector expressions like 
```julia 
u=v-w
```

by either 
```julia
u.= v.-w
```
or the equivalent 

```julia
@. u=v-w
```


##### Rationale
Vector expressions without dot "." result in handling each elementary expression in its own loop over vector length and creating  intermediate values which need to
be allocated.

The dot tells Julia to _fuse_ these loops,
that means the Julia compiler creates exactly one loop which applies the operations component-wise instead of creating code for each operation apart. This removes multiple loop bookkeeping overheads and avoids allocation of memory for intermediate expressions.

Connected to his hint is the fact that unlike with python/numpy, in Julia there is no need to "vectorize" code for performance. Writing your own loops or writing fused vector expressions is sufficient to get full performance with Julia. 


## "Be aware of when Julia avoids specializing"

[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/performance-tips/#Be-aware-of-when-Julia-avoids-specializing)

Moving functions parametrizing the code from global variables to function parameters creates  a new source of allocations.
This can be  removed by type-annotating the newly introduced function parameters.

E.g. for `func` being a function  parameter of `g`, replace

```julia
function  g(func, a,b,c)
...
end
```
by

```julia 
function   g(func::T, a, b,c) where {T}
...
end
```  

#### Rationale

Usually, if Julia is aware of the types of parameters passed to a function, it 
creates specialized code for each combination of type signatures. E.g. 
with a definition `f(x)=x*x` Julia is triggered to create  code for floating point numbers when calling `f(2.0)` and 
for rational numbers when calling `f(2//1)`.  This behavior is called _specialization_.

There are exceptions to this rule. One exception are function parameters.
Julia by default does not specialize on function parameter types (in Julia, each function has its own type), resulting in an allocation when calling the first version of `g(func,a,b,c)`, even when the body of `g` is "allocation free".

Type-annotating `func` in the parameter list of `g` with a [type parameter](https://docs.julialang.org/en/v1/base/base/#where)
 triggers Julia to create specialized code for each function passed.



## "Performance annotations"

[Julia docs 🔗](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-annotations)

Annotate  inner loops with `@fastmath @inbounds` to remove bounds checking and some speed constraints inherent to pure  IEEE floating point arithmetic.


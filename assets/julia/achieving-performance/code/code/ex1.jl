# This file was generated, do not modify it. # hide
using BenchmarkTools # HIDE
a=10 
b=11

function important(x)
   x=5*a+b
end

@btime important(10)
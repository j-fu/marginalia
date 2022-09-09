# This file was generated, do not modify it. # hide
a=10
b=11

function important(x,a,b)
     x=5*a+b
end

@btime important(10,a,b)
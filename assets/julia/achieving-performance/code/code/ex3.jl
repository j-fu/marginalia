# This file was generated, do not modify it. # hide
function run()
  a::Int=10
  b::Int=11

  function important(x)
     x=5*a+b
  end
@btime important(10)
end
run()
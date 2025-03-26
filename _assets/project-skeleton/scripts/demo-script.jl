using Pkg

Pkg.activate(joinpath(@__DIR__,".."))

using {PKGNAME}

println({PKGNAME}.greet())

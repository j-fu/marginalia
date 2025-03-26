using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Comonicon, Pluto

"""
    runpluto(notebook)

Run pluto notebook from commandline
# Args
- `notebook`:  Notebook to run
"""
Comonicon.@main function runpluto(notebook)
    Pluto.run(; notebook, auto_reload_from_file = true)
end

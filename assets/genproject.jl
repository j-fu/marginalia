#!/bin/sh
# Run this file via
# julia --compile=min  genproject.jl projectname 
#

#
# This code is reproduced under the MIT License (c) 2021 J. Fuhrmann 
#

#=
exec julia --compile=min --startup-file=no "$0" "$@"
=#



using ArgParse
using Pkg

MITLicense()="""
Copyright <YEAR> <COPYRIGHT HOLDER>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""



README(name,subname)="""
$(name)
======

## Initial remarks

This is the initial version of the project.

### Running code

Invoke the scripts from a running Julia instance in the package root directory.
Don't forget to activate the project environment by invoking Julia via
```
julia --project=.
```

or by invoking
```
using Pkg
Pkg.activate(".")
```

### Adaptation
- Please check the LICENSE file and replace it by another license if you don't agree with it.
- Please check the `authors` entry in `Project.toml`
- Remove or replace demo scripts, notebooks and `packages/$(subname)`
- Set up a git repo for sharing the code. All subdirectories and top level files in this initial version should be under version control
- Consider introducing  subdirectories for large simulation results which are not under version control due to their size
- Consider introducing further subdirectories to struture your project
- May be DrWatson.jl can be helpful for you. This project structure is compatible to it with two exceptions:
  - It doesn't rely on `@quickactivate`.  It assumes  that the skills obtained by learning how to work with Julia environments are useful
  - Notebooks are assumed to be Pluto notebooks which can be  version controlled in straigtforward way, unlike Jupyter notebooks

### Initial file structure


```
MyProject/
├── Manifest.toml
├── notebooks
│   └── presentation.jl
├── packages
│   └── $(subname)
│       ├── Project.toml
│       └── src
│       │    └── $(subname).jl
│       └── test
│           └── runtests.jl
├── papers
│   └── publication.tex
├── Project.toml
├── scripts
│   └── example.jl
├── src
│   └── MyProject.jl
└── test
    └── runtests.jl
```
The essential role of these files is as follows:
- `Project.toml`: The project file describes the project on a high level, for example the package/project dependencies and compatibility constraints are listed in the project file. See the [documentation](https://pkgdocs.julialang.org/v1/toml-files/#Project-and-Manifest)
- `Manifest.toml`:  The manifest file is an absolute record of the state of the packages in the environment. It includes exact information about (direct and indirect) dependencies of the project. Given a Project.toml + Manifest.toml pair, it is possible to instantiate the exact same package environment, which is very useful for reproducibility. See the [documentation](https://pkgdocs.julialang.org/v1/toml-files/#Manifest.toml)
- `LICENSE`: License of the project. By default it is the MIT license
- `README.md`: This file
- `src`: Subdirectory for project specific code as part of the $(name) package representing the project.
- `test`: Unit tests for project code in `src`. Could include something from `scripts`, `notebooks`.
- `packages`: Subdirectory containing packages developed locally in this project. At some stage these could be turned into separate Julia packages
- `scripts`, `notebooks`: "Frontend" code for creating project results
- `papers`: "Wer schreibt, der bleibt" - besides of coding, you probably should publish your results...
- `docs`: not in this template, but there belong the sources for the docs created with `Documenter.jl`
"""



demonotebook(name,subname)="""### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 60941eaa-1aea-11eb-1277-97b991548781
begin 
	using Pkg
	Pkg.activate(joinpath(@__DIR__,".."))
	using Revise
	using PlutoUI
	using $(name)
	using $(subname)
end

# ╔═╡ 882dda23-63b9-4b1e-a04e-69071deff69a
md"This notebook is only relocateable together with the whole $(name) project."

# ╔═╡ a8e37976-5db2-485f-87aa-0cf7155e8e00
$(name).greet()

# ╔═╡ 73a94305-1c3c-45e5-969f-2a245baec10d
$(subname).greet()

# ╔═╡ Cell order:
# ╠═882dda23-63b9-4b1e-a04e-69071deff69a
# ╠═60941eaa-1aea-11eb-1277-97b991548781
# ╠═a8e37976-5db2-485f-87aa-0cf7155e8e00
# ╠═73a94305-1c3c-45e5-969f-2a245baec10d
"""

demoscript(name,subname)="""            
module DemoScript
using $(name)
using $(subname)
    
function main()
   $(name).greet()
   $(subname).greet()
end

end
"""


maketest(name,subname)="""
using Test
using $(name)
using $(subname)

$(name).greet()

@testset "$(name)" begin
@test true
end
"""

makesubtest(subname)="""
using Test
using $(subname)

$(subname).greet()

@testset "$(subname)" begin
@test true
end
"""



function main(args)
    settings = ArgParseSettings()
    settings.description = "Generate a project template"
    settings.commands_are_required = false
    settings.add_version = true
    add_arg_table(settings,
                  "name", Dict(:help => "Project name",:required => true),
                  "--sub", Dict(:help => "Subpackage name",:required => false, :default => "MySubPackage"),
                  )
    parsed_args=parse_args(args, settings)
    name=parsed_args["name"]
    subname=parsed_args["sub"]


    @info "Generate  $(name)"
    Pkg.generate(name)
    
    cd(name) do
        @info "Activate  $(name)"
        Pkg.activate(".")
        Pkg.add(["Revise","PlutoUI","Pluto","Test"])

        @info "Generate  packages subdirectory"
        mkdir("packages")
        cd("packages") do
            Pkg.generate(subname)
            cd(subname) do
                Pkg.activate(".")
                Pkg.add("Test")
                mkdir("test")
                cd("test") do
                    open("runtests.jl", "w") do io
                        write(io,makesubtest(subname))
                    end
                end
            end
        end
        Pkg.activate(".")

        
        Pkg.develop(path="packages/$(subname)")

        @info "Generate demo notebook"
        mkdir("notebooks")
        cd("notebooks") do
            open("demo-notebook.jl", "w") do io
                write(io,demonotebook(name,subname))
            end
        end

        @info "Generate demo script"
        mkdir("scripts")
        cd("scripts") do
            open("demo-script.jl", "w") do io
                write(io,demoscript(name,subname))
            end
        end
        
        @info "Generate tests"
        mkdir("test")
        cd("test") do
            open("runtests.jl", "w") do io
                write(io,maketest(name,subname))
            end
        end

        @info "Run tests"
        Pkg.test()
        Pkg.test(subname)

        @info "Generate papers, license, readme"
        mkdir("papers")

        open("LICENSE", "w") do io
            write(io,MITLicense())
        end
        
        open("README.md", "w") do io
            write(io,README(name,subname))
        end

        @info "run demo script"
        @show joinpath("scripts","demo-script.jl")
        include(joinpath(pwd(),"scripts","demo-script.jl"))
        Base.invokelatest(DemoScript.main)
        println()
        
        @info "run demo notebook"
        include(joinpath(pwd(),"notebooks","demo-notebook.jl"))
        println()
    end

end

main(ARGS)

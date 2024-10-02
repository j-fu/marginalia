@def tags = ["julia"]
@def rss_description = "Julia: Project Workflow."
@def rss_pubdate = Date(2024, 10, 2)

# Julia: Project Workflow Howto

This post complements the [project workflow recommendations](/julia/project-workflow).
It tries to explain in a more introductory and rather assertive way how to work  on collaborative projects (not packages) in Julia. It is also meant to be an introduction for  collaborators with whome I share a Julia project following these conventions.

\toc 

## The project files
After checking out the project the first time, you will see it populated with a number of files and subdirectories.

The essential role of files a typical Julia project file tree is as follows:
- `Project.toml`: This file describes the project on a high level, including the packages it depends on and their compatibility constraints as [described in "Basic Workflow"](/julia/basic-workflow/#record_your_project_dependencies_in_reproducible_environments).
- `LICENSE`: License of the project.
- `README.md`: A general description of the project
- `src`: Subdirectory for project specific source code shared between scripts and notebooks of the project
- `test`: Unit tests for the project code in `src`. Could include something from `scripts`, `notebooks`.
- `packages`: Subdirectory containing packages developed locally in this project. At some stage these could be turned into separate Julia packages.
- `scripts`: Julia scripts for creating project results. 
- `notebooks`: Interactive notebooks
- `docs`:  Sources for the documentation created with `Documenter.jl`

## Installation and updating of dependent packages
After checking out the code with git, at first it is necessary to instantiate the project environment. Go to the project root directory and invoke
```
$ julia --project=.
julia> using Pkg
julia> Pkg.instantiate()
```
This uses the Julia package manager to automatically download and precompile all Julia packages listed as dependencies in  `Project.toml`. 
It also will create a `Manifest.toml` file which records recursively all dependenencies with their exact versions.

Likewise, after updating some code from the git repository, it is possible to update the project environment:

```
$ julia --project=.
julia> using Pkg
julia> Pkg.update()
```

## Running code
In order to ensure the activation of the project evironment described in `Project.toml`, all scripts and all notebooks
activate the project environment at their respective start. Typically, this looks like
```
Pkg.activate(joinpath(@__DIR__, "..."))
```

### Scripts
To run script `scripts/script1.jl`, perform from the project root:
```
$ julia --project=.
julia> using Revise
julia> includet("scripts/script1.jl")
```
See [here](/julia/basic-workflow/#use_revisejl_to_reload_modified_code) for an explanation of `Revise`

With some precompilation hiatus, it is possible to just run
```
julia scripts/script1.jl
```

### Notebooks
To run the Pluto notebook `notebooks/notebook1.jl`, [install Pluto](https://plutojl.org) in your global environment and perform

```
$ julia 
julia> using Pluto
julia> Pluto.run(notebook="notebooks/notebook1.jl")
```

~~~
<hr size="5" noshade>
~~~
__Update history__
- 2024-10-02: Initial version 

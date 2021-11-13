

Julia Workflow
====================

\toc 


These hints are focused on editing the code in a favorite editor and runing it from the command line. 
Pluto notebooks and Julia's Visual Studio Code extensions provide several more possibilities.




## Basic workflow

Many available Julia examples and  the mindset influenced by Matlab or Python suggest  that one just  starts to  perform everything  in the global context of a script (e.g. `MyScript.jl`)

```
using Package1
using Package2

# action here
```

and running the script via

```
$ julia MyScript.jl
```


However, for Julia this is a bad idea for at  least two reasons:

-  [Type-stable action](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-global-variables) of Julia's just-in-time compiler is possible only for functions, so this code does not optimize well
- One encounters precompilation time hiatus when running after each modified  version

Suggestions:

- Develop any code in functions. E.g. `MyScript.jl` could look like:

```
using Package1
using Package2

function main(; kwarg1=1, kwarg2=2)
 # action here 
end
```

- Invoke the code  from a running julia instance. In this   case you encounter the Read-Eval-Print-Loop (REPL) of Julia. You don't need to leave julia for restarting modified code (except in the case when you re-define a constant or a struct). Just reload the code by repeating the `include` statement:


```
$ julia
julia> include("MyScript.jl")
julia> main(kwarg1=5)
```




-  Think about wrapping code into modules. The previous example can be enhanced by wrapping the code of the script into a module.
   This has the advantage that you can load different scripts into the same session without name clashes.

```
Module MyScript

using Package1
using PackageN

function main(; kwarg1=1, kwarg2=2)
 # action here 
end

end
```

```
$ julia
julia> include("MyScript.jl")
julia> MyScript.main(kwarg1=5)
```


##  Revise.jl

In the previous examples, re-loading the code after modifications required to re-run the include statement. The package 
[Revise.jl](https://github.com/timholy/Revise.jl) adds a command `includet` which triggers automatic recompilation of modified code if the source code of the script file and of packages  used therein changes.

In order to set this up, place the following into the Julia startup file `.julia/config/startup.jl` in your home directory:

```
using Revise
``` 

You would then run:
```
$ julia -i
julia> includet("MyScript.jl")
julia> MyScript.main(kwarg1=5)
```
After changing `MyScript.jl`, just another  invocation of `MyScript.main`  would see the changes.


In addition, `Revise.jl` also tracks source code of packages added via `using`, and it also works for [Pluto notebooks](https://github.com/fonsp/Pluto.jl).

## Environments

By default, packages added to the Julia installation are recorded in the default _global environment_:
```
$ julia
julia>]
pkg> add Package1
```
results in a corresponding entries in  `.julia/environments/v1.x/Project.toml`  and `.julia/environments/v1.x/Manifest.toml` .
Sharing this global  environment between all your different projects is risky because of possible conflicts in package version requirements.



_Local environments_ provide a remedy.

Assume that a _project_ is Julia code residing in a given directory `project_dir`, uses one or several other Julia packages and is not intended to be invoked from other projects. An environment is described by a `Project.toml` file in the project directory . One can set up an environment
in the following way:

```
$ cd project_dir
$ julia
$ pkg> activate .
$ pkg> add Package1
$ pkg> add PackageN
$ exit()
```
After setting up the environment like this, you can  perform

```
$ cd project_dir
$ julia --project=@.
```
and work in the environment. All packages added in this case affect only this enviroment. All packages added to the global environment still will be visible.

When it comes to versioning, the `Project.toml` file should be checked in along with the source code, so another project collaborator can easily establish a similar environment via

```
$ cd project_dir
$ julia --project=.
$ pkg> instantiate
```
When instantiated, a `Manifest.toml` file appears which holds the information about the exact versions of all Julia packages used by the project.  Putting this under version control would allow to establish the exact versions of Julia packages necessary to establish a given result. 

See also the corresponding [documentation](https://pkgdocs.julialang.org/v1.2/environments/)



## An idea for structuring a Julia project

Up to now, it was assumed that one works with a couple of scripts. For a larger project, more structure of the code is needed. In particular, different project scripts may share some parts of the code, and may be  some of this code slowly turns into a package.
The following recommendations are partially inspired by B. Kaminski's [post on project workflow](https://bkamins.github.io/julialang/2020/05/18/project-workflow.html) and  by the  [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) package of G. Datseris.


- Generate the project directory itself as a package (named e.g. `MyProject`) using [`Pkg.generate`](https://pkgdocs.julialang.org/v1/creating-packages/) or [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl). This has the following advantages:
   - easy way to share  the code in the `src` folder among different project scripts via `using MyProject`
   - availability of Julia's  test and documentation functionality for the project
- Optionally have a folder `packages` which contains other sub-packages.
  As [relative paths are recorded in Manifest.toml](https://github.com/JuliaLang/Pkg.jl/issues/1214), these can be made available the project via `Pkg.develop(path="packages/MySubPackage")`. In this case, the whole project  tree will stay relocateable.
   - This allows for easy start of low key package development. At a later stage, `MySubPackage` could be registered as a Julia package and removed from the project tree without affecting  scripts depending on it. 
- When working with the project, always run julia from the package root with the package environment activated: `julia --project=.` 
- Assume Pluto notebooks to be in `notebooks` and call  `Pkg.activate(joinpath(@__DIR__,".."))` in their Pkg cell to activate the project environment.  As a consequence, the Pluto notebooks will share the project environment, and they can't be redistributed independent of the project.
- You may use [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) for managing subdirectory access and simulation results. By explicitely activating the project environment at the start of Julia or in the notebook Pkg cell, you can avoid  `@quickactivate` and  avoid putting `using DrWatson` into script files and notebooks. See also [this discussion](https://github.com/JuliaDynamics/DrWatson.jl/issues/261).


A sample project tree could e.g. look like this
```
MyProject
├── LICENSE
├── Manifest.toml
├── notebooks
│   └── demo-notebook.jl
├── packages
│   └── MySubPackage
│       ├── Manifest.toml
│       ├── Project.toml
│       ├── src
│       │   └── MySubPackage.jl
│       └── test
│           └── runtests.jl
├── papers
├── Project.toml
├── README.md
├── scripts
│   └── demo-script.jl
├── src
│   └── MyProject.jl
└── test
    └── runtests.jl
```
You can download the Julia script [genproject.jl](/assets/genproject.jl) and generate this structure a subdirectory via
```
julia --compile=min genproject.jl name_of_your_project
```
Adapt it to your needs.

__Project strucure summary__
- Shared code among scripts or  notebooks is either placed in `src` as part of the `MyProject` package, or in package in `packages`
- Script functionality should be developed in functions, avoiding global variables
- Scripts can contain modules in order to separate their namespaces.
- Pluto notebooks should activate the enviromnent in the root directory of `MyProject`
- Write tests 

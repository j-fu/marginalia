

Julia Workflow Hints
====================

\toc 

These workflow hints have been developed from my own experience and are essentially an illustration of the [workflow tips](https://docs.julialang.org/en/v1/manual/workflow-tips)  found in the Julia documentation. The ideas on project structuring are partially inspired by B. Kaminski's post on  [project workflow](https://bkamins.github.io/julialang/2020/05/18/project-workflow.html) and  the  [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) package by G. Datseris.


## Never leave Julia and  write code in functions

Many available Julia examples and  the mindset influenced by Matlab or Python suggest  that code is written in scripts where  computations are performed in the global context. E.g.  a script `MyScript.jl` would look like:

```
using Package1
using Package2

# computations here
...
```

and executed like

```
$ julia MyScript.jl
```


However, for Julia this is a bad idea for at  least two reasons:

-  Type-stable action of Julia's just-in-time compiler is possible only for functions, so this code does not optimize well
- One encounters precompilation time hiatus when running after each modified  version

Suggestions:

- [Avoid global variables](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-global-variables) and develop any code in functions. E.g. `MyScript.jl` could look like:
```
using Package1
using Package2

function main(; kwarg1=1, kwarg2=2)
 # action here 
end
```

- Always invoke the code from within a running julia instance. In this   case you encounter the [Read-Eval-Print-Loop (REPL)](https://docs.julialang.org/en/v1/manual/workflow-tips/#REPL-based-workflow) of Julia. You don't need to leave julia for restarting modified code (except in the case when you re-define a constant or a struct). Just reload the code by repeating the `include` statement:


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


## Use Revise.jl to reload modified code

In the previous examples, re-loading the code after modifications required to re-run the include statement. The package [Revise.jl](https://github.com/timholy/Revise.jl) exports a function `includet` which triggers automatic recompilation  if the source code of the script file or of packages used therein has been modified.


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
After having modified `MyScript.jl`, just another  invocation of `MyScript.main()`  would see the changes. See also the corresponding hints in the [Julia documentation](https://docs.julialang.org/en/v1/manual/workflow-tips/#Revise-based-workflows).

Besides of tracking scripts loaded into the REPL, `Revise.jl` 
- tracks changes in packages under development loaded into the script via `using` or `import`.
- works in [Pluto notebooks](https://github.com/fonsp/Pluto.jl)

## Record your project dependencies in reproducible environments

By default, packages added to the Julia installation are recorded in the default _global environment_:
```
$ julia
julia>]
pkg> add Package1
```
This results in  corresponding entries in  `.julia/environments/vx.y/Project.toml`  and `.julia/environments/vy.y/Manifest.toml`  (where `x.y` stands for your installed Julia version).
Sharing this global  environment between all your different projects is risky because of possible conflicts in package version requirements. In addition, relying on the global environment makes it hard to share your code with others, as you would have to find a way to communicate the packages (with versions) which they need to install to run your code.



_Local environments_ provide a remedy.

Assume that a _project_ is Julia code residing in a given directory `MyProject`, uses one or several other Julia packages and is not intended to be invoked from other projects. An environment is described by the two files in the `MyProject` directory:  `Project.toml` and `Manifest.toml`.
Set up an environment in the following way:

```
$ cd MyProject
$ julia
$ pkg> activate .
$ pkg> add Package1
$ pkg> add PackageN
$ exit()
```
After setting up the environment like this, you can  perform

```
$ cd MyProject
$ julia --project=.
```
and work in the environment. All packages added  to Julia in this case are recorded in `MyProject` instead of `.julia/environments/vx.y/`. Packages in the global environment still will be visible to your project.


The  `Project.toml` file lists the packages added to the environment. In addition, a `Manifest.toml` file appears which holds the information about the exact versions of all Julia packages used by the project. Both  should be checked into version control along with the source code.
If you took care about adding all necessary dependencies to the local environment, after checking out your code, another project collaborator can easily install all dependencies via

```
$ cd MyProject
$ julia --project=.
$ pkg> instantiate
```

See also the corresponding documentation on [environments](https://pkgdocs.julialang.org/v1/environments/) and [`Project.toml` and 
`Manifest.toml`](https://pkgdocs.julialang.org/v1/toml-files/).


Pluto notebooks have their own [built-in package management](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%8E%81-Package-management) and by default     contain a `Project.toml` and a `Manifest.toml` file to ensure portability.

## Take advantage of Julia's package management to structure larger projects

Up to now, it was assumed that one works with a couple of scripts in a subdirectory. For a larger project, more structure of the code is needed:
- different project scripts and Pluto notebooks may share some parts of the code, and you want to avoid [repeating yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
- modularization of the project code can facilitate maintenance and extendability
- may be some of the code slowly turns into a package
- you want to have unit testing available in the project
- the whole project directory _still_ shall be shareable with collaborators in a reproducible way

The following recommendations are partially inspired by B. Kaminski's post on  [project workflow](https://bkamins.github.io/julialang/2020/05/18/project-workflow.html) and  the  [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) package by G. Datseris.


- Generate the project directory itself as a package (named e.g. `MyProject`) using [`Pkg.generate`](https://pkgdocs.julialang.org/v1/creating-packages/) or [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl). This has the following advantages:
   - easy way to share  the code in the `src` folder among different project scripts via `using MyProject`
   - availability of Julia's  test and documentation functionality for the project
- Optionally have a folder `packages` which contains other sub-packages.
  As [relative paths are recorded in Manifest.toml](https://github.com/JuliaLang/Pkg.jl/issues/1214), these can be made available the project via `Pkg.develop(path="packages/MySubPackage")`. In this case, the whole project  tree will stay relocateable.
   - This allows for easy start of low key package development. At a later stage, `MySubPackage` could be registered as a Julia package while still residing in the project teee, or even removed from the project tree without affecting  scripts depending on it. 
- When working with the project, always run julia from the package root with the package environment activated: `julia --project=.` 
- Assume project specific Pluto notebooks to reside in a  `notebooks` subdirectory  and call  `Pkg.activate(joinpath(@__DIR__,".."))` in their respective Pkg cell to activate the `MyProject` environment.  As a consequence, Pluto's in-built package manager will be disabled and the project specific notebooks will share the `MyProject` environment and _cannot be shared independent from the `MyProject` tree_ (If independent sharing is desired, common project code can be collected into a package residing in `packages` and registered in a registry; registering `MyProject` itself as a package is not recommended.  -- More about this in another post).

- You may use [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) for managing subdirectory access, simulation results and version tagging. By explicitely activating the project environment at the start of Julia or in the notebook Pkg cell, you can avoid  `@quickactivate` and  avoid putting `using DrWatson` into script files and notebooks for the sole purpose of activating the common environment. See also [this discussion](https://github.com/JuliaDynamics/DrWatson.jl/issues/261).


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
You can download the Julia script [genproject.jl](/assets/genproject.jl) and generate this structure a subdirectory on your computer via
```
julia --compile=min genproject.jl name_of_your_project
```
Feel free to adapt the generated directory tree to your needs and don't forget to make a git repository out of it as early as possible.

## TL;DR
- Script functionality should be developed in functions, avoiding global variables
- Create a project specific environment as a project-package
- Use the REPL and  Revise.jl, start julia in the activated project environment
- Place shared code among project specific  scripts or  notebooks either in the `src` subdirectory as part of the project-package, or in a  sub-package in a subdirectory of the project-package
- Separate namespaces of scripts by using  modules
- Activate the shared project environment of the project-package in project specific Pluto notebooks. 
- Write tests and examples

By taking advantage of Julia's best-in-class package management facilities, the proposed approach goes a long way in the direction of maintaining sustainable research software. From a [talk by A. Zeller](https://de.slideshare.net/andreas.zeller/sustainable-research-software):
1. Have a repo ✓
2. Anyone can build ✓
3. Have tests ✓
4. Be open for extensions ✓
5. Have examples ✓

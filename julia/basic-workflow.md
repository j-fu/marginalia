@def tags = ["julia"]
@def rss_description = "Julia: Basic Workflow."
@def rss_pubdate = Date(2022, 2, 9)


# Julia: Basic Workflow Recomendations


\toc 

These workflow hints have been developed from my own experience and are essentially an illustration of the [workflow tips](https://docs.julialang.org/en/v1/manual/workflow-tips)  found in the Julia documentation. 

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


### [Avoid  untyped global variables](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-global-variables) 

Develop any code in functions. E.g. `MyScript.jl` could look like:
```
using Package1
using Package2

function main(; kwarg1=1, kwarg2=2)
 # action here 
end
```
### Load code into the REPL via `include()`
Always invoke the code from within a running julia instance. In this   case you encounter the [Read-Eval-Print-Loop (REPL)](https://docs.julialang.org/en/v1/manual/workflow-tips/#REPL-based-workflow) of Julia. You don't need to leave julia for restarting modified code (except in the case when you re-define a constant or a struct). Just reload the code by repeating the `include` statement:


```
$ julia
julia> include("MyScript.jl")
julia> main(kwarg1=5)
```




### Think about wrapping code into modules

The previous example can be enhanced by wrapping the code of the script into a module. This has the advantage that you can load different scripts into the same session without name clashes.

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

### Load modules into the REPL via `using`
Alternatively, load code via `using`. Once you have mastered modules and ensured that the file name corresponds to the module name, you can  load code via `using`. In order to allow for this, you need to ensure to have the directory containing `MyScript.jl` (e.g. the current directory `pwd()`) on the [`LOAD_PATH`](https://docs.julialang.org/en/v1/base/constants/#Base.LOAD_PATH):
```
$ julia
julia> push!(LOAD_PATH,pwd())
julia> using MyScript
julia> MyScript.main(kwarg1=5)
```
``LOAD_PATH`` can also be passed to Julia as an environment variable defined before the invocation of julia.
In order to allow this to work, the directory of `MyScript.jl` *should not constitute an [environment](/julia/basic-workflow/#record_your_project_dependencies_in_reproducible_environments)*, i.e. it should contain neither a `Project.toml` nor a `Manifest.toml` file.

## Use Revise.jl to have modified code reloading automatically

In the previous examples, re-loading the code after modifications required to re-run the include statement. The package [Revise.jl](https://github.com/timholy/Revise.jl) exports a function `includet` which triggers automatic recompilation  if the source code of the script file or of packages used therein has been modified.

In order to set this up, after invoking `Pkg.add("Revise")` once, place the following into the Julia startup file `.julia/config/startup.jl` in your home directory:

```
using Revise
``` 

### Load code into the REPL via `Revise.includet()`

You would then run:
```
$ julia -i
julia> includet("MyScript.jl")
julia> MyScript.main(kwarg1=5)
```
After having modified `MyScript.jl`, just another  invocation of `MyScript.main()`  would see the changes. See also the corresponding hints in the [Julia documentation](https://docs.julialang.org/en/v1/manual/workflow-tips/#Revise-based-workflows).


### Loading modules into the REPL via `using` allows to track all included files
If `MyScript.jl` itself uses `include()` to load more code, `Revise.jl` is unable to track
changes in the included code if `MyScript.jl` has been loaded via `includet`. This problem however
is mitigated by [loading `MyScript.jl` via `using`](/julia/basic-workflow/#load_code_into_the_repl_via_using).
This is true as well for modules and packages under development loaded into the script via `using` or `import`.
In particular, this way, `Revise.jl` also works in [Pluto notebooks](https://github.com/fonsp/Pluto.jl) when the inbuilt package manager has been disabled.


## Record project dependencies in reproducible environments
In julia, an [environment](https://docs.julialang.org/en/v1/manual/code-loading/#Environments) determines which code is loaded via `import X` and `using X`. An environment can be described using a `Project.toml` file in a certain directory. This file contains a list of packages available for loading via `import` or `using`.

### Global environment
By default, packages added to the Julia installation are recorded in the default _global environment_:
```
$ julia
julia> using Pkg
julia> Pkg.add("Package1")
```
This results in  corresponding entries in  `.julia/environments/vx.y/Project.toml`  and `.julia/environments/vx.y/Manifest.toml`  (where `x.y` stands for your installed Julia version, e.g. 1.10).
If no other measures are taken, all your julia code will look into this environment in order find the a package to be loaded via `using` or `import`.

Sharing this global  environment between all your different projects is risky because of possible conflicts in package version requirements. In addition, relying on the global environment makes it hard to share your code with others, as you would have to find a way to communicate the names of the  packages (with versions) which they need to install to run your code in a reproducible way.

### Local environments
_Local environments_ provide a remedy.

Assume that an  _application_ is Julia code residing in a given directory `MyApp`, uses one or several other Julia packages and is not intended to be invoked from other packages or applications. 
Set up an environment in  the project directory in the following way:
```
$ cd MyApp
$ julia --project=.
julia> using Pkg
julia> Pkg.add("Package1")
julia> Pkg.add("Package2")
$ exit()
```
This creates an  environment in `MyApp` directory  described by the two files `MyApp/Project.toml` and `MyApp/Manifest.toml`. The  `Project.toml` file lists the packages added to the environment. In addition, the `Manifest.toml` file a holds the information about the exact versions of all Julia packages used by the project.

After setting up the environment like this, you can  perform

```
$ cd MyApp
$ julia --project=.
```
and work in the environment. All packages added  to Julia in this case are recorded in `MyApp` instead of `.julia/environments/vx.y/`. 

 
`Project.toml`  should be checked into version control along with the source code. If you took care about adding all necessary dependencies to the local environment, after checking out your code, another project collaborator can easily install all dependencies via
```
$ cd MyApp
$ julia --project=.
$ julia> using Pkg
$ julia> Pkg.instantiate()
```

If `Manifest.toml` is distributed and checked into version control along with `Project.toml`, `instantiate` will install the exact same package versions as recorded in the manifest.

### Enviroment stacking
After activating a local environment, packages in the global environment still will be visible to your project.
You can use this to keep available utilities your project should not depend upon, but which are useful during development. This could e.g. be `BenchmarkTools`, `JuliaFormatter` etc.


### Shared ("`@`") Environments
Since Julia 1.7 it is possible to easily work with different more or less global environments:
```
$ julia --project=@myenv
```
calls Julia and activates the environment `.julia/environments/myenv`


### Further info
- [Modern Julia Workflows](https://modernjuliaworkflows.github.io/):  Best practices for Julia development.

- My [talk](https://www.wias-berlin.de/people/fuhrmann/AdSciComp-WS2223/week3/#reproducibility_infrastructure_of_the_julia_language) on the reproducibility infrastructure of the Julia language

- Documentation on [environments](https://pkgdocs.julialang.org/v1/environments/) and [`Project.toml` and  `Manifest.toml`](https://pkgdocs.julialang.org/v1/toml-files/).

- Pluto notebooks have their own [built-in package management](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%8E%81-Package-management) and by default     contain a `Project.toml` and a `Manifest.toml` file to ensure portability.

- [Blogpost](https://jkrumbiegel.com/pages/2022-08-26-pkg-introduction/) by Julius Krumbiegel for another take on Julia environments.



~~~
<hr size="5" noshade>
~~~

__Update history__
- 2024-10-07: Package directories on LOAD_PATH should not contain Project.toml; multiple reformulations
- 2024-10-02: Make Manifest check-in optional, upvote  "Modern julia workflows"
- 2023-10-17: Link to modern julia workflows
- 2023-04-24: Smaller improvements
- 2022-11-06: `@` environments (since Julia 1.7) + LOAD_PATH, link to my talk on Julia's reproducibility infrastructure
- 2022-09-01: Link to [blogpost](https://jkrumbiegel.com/pages/2022-08-26-pkg-introduction/) by Julius Krumbiegel
- 2022-02-09: RSS
- 2021-11-15: Initial version

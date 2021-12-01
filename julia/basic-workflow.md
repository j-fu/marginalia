@def tags = ["julia"]


Julia: Basic Workflow
=====================
Initial version: 2021-11-15


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
Sharing this global  environment between all your different projects is risky because of possible conflicts in package version requirements. In addition, relying on the global environment makes it hard to share your code with others, as you would have to find a way to communicate the names of the  packages (with versions) which they need to install to run your code.



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


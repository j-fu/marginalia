
## Package development
For general terminology, see the [package manager glossary](https://pkgdocs.julialang.org/v1/glossary/#Glossary). According to this, here, we assume that a  _package_ is Julia which is supposed to be used by other projects or packages.

https://medium.com/coffee-in-a-klein-bottle/developing-your-julia-package-682c1d309507
https://jaantollander.com/post/how-to-create-software-packages-with-julia-language/
https://www.stochasticlifestyle.com/developing-julia-packages/

When developing Julia packages it is advisable to set the environment variable [`JULIA_PKG_DEVDIR`](https://pkgdocs.julialang.org/v1/api/#Pkg.develop) to reasonable path. All Julia packages under development will reside there, and for a particular package, we refer to its corresponding `package_dir`  during this post.



### Starting a package as part of an application project
Often, packages evolve during the development of larger application, when it becomes clear that some part of it provided some well defined functionality which can be formulated with its own API.  Local packages within an application project allow to start the package development process.  For this structure, see [my previous post](/julia/project-workflow).


### Starting a package repository




Create and  empty repo `NewPackageName.jl` on a server with `git_url`
```
$ cd $JULIA_PKG_DEVDIR
$ julia
pkg> generate NewPackageName
julia> exit()
cd NewPackageName
git init
git add remote origin git_url
git add .
```


Julia packages have a fixed structure which includes
- `Project.toml`: description of dependencies. This also provides the packages with its own environment during development.
  Furthermore, it contains the uuid used to identify the package and its name, author and version number.
  More [here](https://pkgdocs.julialang.org/v1/toml-files/).
- `Manifest.toml` full metadata of dependency. This file should not be tracked by git.
- `src`: subdirectory containing code
   - `src/NewPackageName.jl`: Julia source file which must contain a module `NewPackageName` where all package code resides.
- `test`: subdirectory containing test code
   - `test/runtests.jl`: script for running tests
- `docs`: subdirectory containing documentation 
   - `docs/make.jl`: script for builidng documentation based on Documenter.jl

Instead of invoking `pkg> generate NewPackageName`, a more comprehensive initial package structure can be be created
with [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl) and [Example.jl](https://github.com/JuliaLang/Example.jl).
These also create the necessary files for controlling automatic CI tests on github/gitlab.


### Using  a package under development




While the package is unregistered you can add it to the
environment of a project:
```
$ cd project_dir
$ julia --project=@.
pkg> add git_url
```
In this case, the version in the git repository on the server is used via a shallow clone (clone without versioning information) created in `$HOME/.julia/packages`. If you use
```
pkg> dev git_url
```
instead, a full clone is created in `$JULIA_PKG_DEVDIR` and used. If the corresponding subdirectory
in `JULIA_PKG_DEVDIR` does not exist, it will be checked out from `git_url`. The same would
happen with registered packages added by name.




## Registration of a new package or a new version

We assume to speak about `WIASJuliaRegistry` as an example, but generally this is true for all registries. 

### Without write access to this repository

Send an  email to  one of  the admins  containing the  git url  of the corresponding repository singnaling the advance of a new version.  The `Project.toml` file already should contain the new version number.

### With write access to this repository

Add the [LocalRegistry.jl](https://github.com/GunnarFarneback/LocalRegistry.jl) package to your environment
```
pkg>  add LocalRegistry
```


For a new package `X.jl` or a new version thereof, first obtain a clone, either by checking it out via its url, or by adding it to the environment, getting into develop mode and updating it:
```
pkg> add X
pkg> develop X
pkg> update X # not clear if really necessary
```

Then, you will be able to register a new version based on the updated version number in `Project.toml`:

```
julia> using X
julia> using LocalRegistry
julia> LocalRegistry.register(X,"WIASJuliaRegistry",push=true)
```

This assumes that the remote origin of the local clone in `.julia/registries/WIASJuliaRegistry` has been modified to `git@github.com:WIAS-BERLIN/WIASJuliaRegistry`.
The `push=true` can be omitted, in this case, `LocalRegistry.Register` results in a commit to the local copy which you can push later.

After this, do not forget to create a tag in your repository marking the version  ` x.y.z ` of the package:

```
$ git tag vx.y.z
```

## Using the General registry
Registring packages in the general registry assumes full compliance to a number of rules:

- Package is deployed with automatic testing on github (at least this is the current practice) with [travis, deploydocs etc. enabled](https://juliadocs.github.io/Documenter.jl/stable/man/hosting/index.html)

- Don't forget compat info for  julia and all packages  in Project.toml
- Proper versioning sequence
- Must wait 3 days for merge for  new package
- Must wait $\approx$ 1 hour for new version

All of this is automatically handeled by the [JuliaRegistrator](https://github.com/JuliaRegistries/Registrator.jl)
 
~~~
<div class="img-small">
<img src="https://raw.githubusercontent.com/JuliaRegistries/Registrator.jl/master/graphics/logo.png">
</div>
~~~

It needs to be installed as a github app in for the package repository.


## Naming and versioning
- Registration in the general registry starts with version 0.1.0, all deviations from this will create extra work
  upon registration in the general registry.
- Either name a "budding package" (e.g. Ants.jl) accordingly: AntsPrototype.jl, Ants0.jl 
  have a version number conventiom.

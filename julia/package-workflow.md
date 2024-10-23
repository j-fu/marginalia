@def tags = ["julia"]
@def rss_description = "Julia: Package Workflow."
@def rss_pubdate = Date(2023, 4, 24)

# Julia: Package Workflow
(Draft, work in progress)

\toc

## Resources

- Some other useful introductions to package authoring
  - G. Dalle, J. Smit, A. Hill: [Modern Julia Workflows](https://modernjuliaworkflows.github.io/) (2024-09)
  - Jaan Tollander de Balsch:  [How to Create Software Packages with Julia Language](https://jaantollander.com/post/how-to-create-software-packages-with-julia-language/) (2021-05)
  - Sören Dobberschütz: [Tips and tricks to register your first Julia package](https://sdobber.github.io/juliapackage/) (2021-10)
  - Kim Fung: [An Introduction to Continuous Integration & GitHub Actions for Julia](https://medium.com/analytics-vidhya/an-introduction-to-continuous-integration-github-actions-for-julia-1a5a1a6e64d6) (2020-01)
  - Christopher Rackauckas: [Developing Julia packages (video)](https://www.stochasticlifestyle.com/developing-julia-packages/) (2019-10)

- [Package manager glossary](https://pkgdocs.julialang.org/v1/glossary/#Glossary). According to this, here, we assume that a  _package_ is Julia code which is supposed to be used by other projects, applications or packages.


## Starting a package

### Where do packages under development reside ?
When developing Julia packages it is advisable to set the environment variable [`JULIA_PKG_DEVDIR`](https://pkgdocs.julialang.org/v1/api/#Pkg.develop) to a path convenient for you.
By default (if [`JULIA_DEPOT_PATH`](https://docs.julialang.org/en/v1/manual/environment-variables/#JULIA_DEPOT_PATH) was not changed) it is `.julia/dev`. Julia packages checked out for development via `Pkg.develop()`  will reside there, and it is convenient to have all packages under development in this path.

### Starting a package repository
The [creating packges](https://pkgdocs.julialang.org/v1/creating-packages/) chapter of the package manager documentation explains how to create a package with a minimal functional structure. Enabling important aspects of package workflow like  continuous integration, documentation generation or git integration would involve the addition of all of this tooling by hand.

The package [PkgTemplates.jl](https://github.com/JuliaCI/PkgTemplates.jl) provides standard templates for creating Julia packages:

```
$ cd $JULIA_PKG_DEVDIR
$ julia
julia> using PkgTemplates
julia> t = Template(;
    user="UserName",
    dir=".",
    julia=v"1.10",
    plugins=[
    Git(; manifest=false, ssh=true),
    GitHubActions(),
    Codecov(),
    Documenter{GitHubActions}(),
    ],
    )

julia> t("MyPkg")
```

This creates a standard Julia package structure enhanced with tooling for CI, documentation, git etc.,
which is ready to be pushed to a corresponding github repository:

```
MyPkg
├── .git
│  ...
├── .github
│  ├── dependabot.yml
│  └── workflows
│     ├── CI.yml
│     ├── CompatHelper.yml
│     └── TagBot.yml
├── .gitignore
├── docs
│  ├── make.jl
│  ├── Manifest.toml
│  ├── Project.toml
│  └── src
│     └── index.md
├── LICENSE
├── Manifest.toml
├── Project.toml
├── README.md
├── src
│  └── MyPkg.jl
└── test
   └── runtests.jl
```


- [`Project.toml`](https://pkgdocs.julialang.org/v1/toml-files/#Project.toml): description of dependencies. This also provides the package with its own environment during development. It contains the universally unique identifier (UUID) used to identify the package and its name, author and version number.
- `README.md`: Short information about the package. This will occur on the landing page  of the github repository
- `LICENSE`: License information. Should be one of the [OSI approved](https://opensource.org/licenses) open source license if the package shall be registered with the Julia General Registry
- `src`: subdirectory containing code
   - `src/MyPkg.jl`: Julia source file which must contain a module `NewPackageName` where all package code resides. It may include further source code files.
- `test`: subdirectory containing test code
   - `test/runtests.jl`: script for running tests
   - `test/Project.toml`: (optional) environment file containing test only dependencies
- `docs`: subdirectory containing documentation
   - `docs/make.jl`: script for building documentation based on Documenter.jl
   - `docs/Project.toml`: environment file containing dependencies for documentation
- `.github` Configuration files for Continuous Integration
   -  [`.github/dependabot.yml`](https://discourse.julialang.org/t/psa-use-dependabot-to-update-github-actions-automatically/96001/2?u=j-fu): github action which triggers a pull request if a workflow file has a new version
   - `.github/workflows/CI.yml` Control file for running continuous integration tests on github
   - `.github/workflows/CompatHelper.yml`  github action which triggers a pull request if a package dependency has a new breaking version
   - `.github/workflows/TagBot.yml`  github action which automatically creates git tags for newly registered versions of `MyPkg`.
   - A  [`Manifest.toml`](https://pkgdocs.julialang.org/v1/toml-files/#Manifest.toml) file is created as soon as the package environment is instantiated. It contains the full metadata of  all package dependencies. This file _should not be tracked by git_. Instead, the `Project.toml` shall contain a `[compat]` section which inform the package resolver about the compatibility with different versions of dependencies.



## Tests
See also the [Pkg documentation](https://pkgdocs.julialang.org/v1/creating-packages/#Adding-tests-to-the-package).

The files in `test` provide the environment and the code to run tests of the functions implemented in the package. While it is hard to have 100% test coverage of the package functionality, one should strive to achieve this goal. Besides of the obvious reasons of reproducibility,  peer pressure etc., sufficient test coverage helps to keep a package author sane.
Imagine the need to change something in the  package three years after the last serious work on it...


It is quite possible that tests have more dependencies than the package itself. Therefore Julia packages can have their own test environment in `test/Project.toml`. Alternatively, the test dependencies can be listed in an "[extras]" section of `MyPkg/Project.toml`. The `test/runtests.jl` file contains the code for the tests.
All code called from the [`@test`](https://docs.julialang.org/en/v1/stdlib/Test/#Test.@test) macro is part of the test coverage. A simple file `runtests.jl` contains e.g.:
```
using Test

@test 1+1 == 2
```

Tests code can be called in different ways. In the package root environment:
```
julia> Pkg.test()
```
or from the `Pkg` prompt:
```
] test
```

The seame test can be invoked also in any environment with the package added:
```
julia> Pkg.test("MyPkg")
```
or
```
] test MyPkg
```

## Documentation

### Generation using [Documenter.jl](https://documenter.juliadocs.org/stable/)
Documenter collects the docstrings of functions of a package and builds a documentation website.
If `MyPkg` contains code with docstrings like

```
"""
    mult(x,y)

Calculates the product of `x` and `y`
"""
function mult(x,y)
    return x*y
end
```

In a documentation markdown file this can be referred to in a "[@docs block](https://documenter.juliadocs.org/stable/man/syntax/#@docs-block)".

Documentation is built using the script `docs/make.jl` which needs to be started in the environmet
defined in `docs`:
```
$ julia --project=docs
julia> include("docs/make.jl")
```

### Local preview using [LiveServer.jl](https://github.com/JuliaDocs/LiveServer.jl)
By default, locally built documentation is created in the `docs/build` subdirectory.
Preview can be performed using a local webserver pointing to this directory.

[LiveServer.jl](https://github.com/JuliaDocs/LiveServer.jl) provides one:

```
julia> using LiveServer
julia> serve(dir="docs/build", port=8001)
```
This starts a web browser pointing to `http://localhost:8100`, allowing to navigate documentations locally.

## Running things on github

For public repositories, github provides unlimited access to [Github actions](https://docs.github.com/en/actions/writing-workflows/quickstart). This means that the
scripts under `.github/workflows` are active and triggered at the events described therein.
Among others, the `CI.yml` triggers running of tests and documentation at every push to the main branch.

The script tries to deploy the documentation to a separate branch which publishes the documentation
under `https://github.io/UserName/MyPkg`. For this purpose, github actions need to authenticate theselves
with the repository. For this purpose, a `DOCUMENTER_KEY` ssh key needs to be stored in the repository.
The setup is described in the [Documenter.jl documentation](https://documenter.juliadocs.org/stable/lib/public/#DocumenterTools.genkeys).


Alternatively, this can be done for [gitlab](https://discourse.julialang.org/t/julia-and-gitlab-self-hosted-a-state-of-the-art/86685) as well.


## Providing packages to others

### Using a package under development

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



### Registration of a new package or a new version in a local registry

A registry is a git repository containing package information which allows to find the package source code
given the package name. By default, julia packages are found in the General registry, wich is also installed
by default. However, it is possible to have multiple registries, and to maintain your own registry.

The [LocalRegistry.jl](https://github.com/GunnarFarneback/LocalRegistry.jl) allows for an easy workflow.

We assume to speak about `MyRegistry` as an example, but generally this is true for all registries.
Assuming write access to the repository containing `MyRegistry`, the process is the following:

Registring a new version of MyPkg goes as simple as follows:
```
MyPkg$ julia --project
julia> using MyPkg
julia> using LocalRegistry
julia> LocalRegistry.register(X,"MyRegistry", push=true)
```
After this, do not forget to create a tag in your repository marking the version  ` x.y.z ` of the package:

```
$ git tag vx.y.z
```

If users want to access `MyPkg` via this registry, they first need to add the registry to their
julia installation:
```
julia> Pkg.Registry.add("https://github.com/UserName/MyRegistry")
```

After that, they can add the package as usual:
```
julia> Pkg.add("MyPackage")
```
### Using the General registry
Registering and updating packages in the general registry
is automatically handeled by the [JuliaRegistrator](https://github.com/JuliaRegistries/Registrator.jl) github app.

It assumes compliance to a number of
[heuristic rules](https://juliaregistries.github.io/RegistryCI.jl/stable/guidelines/) concerning package names,
Project.toml content etc.

If these are followed, just comment the most recent commit of your package with
```
@JuliaRegistrator register
```
and the process starts. JuliaRegistrator checks compliance to the rules, and finally merges the updated
information into the General registry
  - after 3 days for a new package
  - after  $\approx$ 20 min for a new version


~~~
<div class="img-small">
<img src="https://raw.githubusercontent.com/JuliaRegistries/Registrator.jl/master/graphics/logo.png">
</div>
~~~

It needs to be installed as a github app in for the package repository.







~~~
<hr size="5" noshade>
~~~
__Update history__
- 2024-10-23: Fundamental update
- 2023-04-24: Draft updated + made public
- 2022-12-06: First draft

@def tags = ["julia"]
@def rss_description = "Julia: Project Workflow."
@def rss_pubdate = Date(2022, 2, 9)

# Julia: Project Workflow Recommendations

\toc 

The term "project" in this post corresponds to the term "application" in [package manager glossary](https://pkgdocs.julialang.org/v1/glossary/#Glossary)

## Rationale
Some ideas on basic julia workflow  are given  [here](/julia/basic-workflow).
For a larger project, structuring of the project code is essential for many reasons, some of them are:
- Different project scripts and Pluto notebooks may share some parts of the code, and you want to avoid [repeating yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).
- Modularization of the project code should facilitate maintainability and extendability.
- May be some of the code slowly turns into a package.
- You want to have unit testing available in the project.
- The whole project directory _still_ shall be shareable with collaborators in a reproducible way.

Morevover, it is important to prevent package compatibility clashes between different projects. Therefore, perhaps, the most important feature of the approach described consists in the idea that each project has its own package
environment, as described in ["Basic Workflow"](/julia/basic-workflow/#record_project_dependencies_in_reproducible_environments).

## Recommendations
The following recommendations are partially inspired by B. Kaminski's post on  [project workflow](https://bkamins.github.io/julialang/2020/05/18/project-workflow.html) and  the  [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) package by G. Datseris.


### Generate the project directory itself as a package
Name this e.g. `MyProject`. Use[`Pkg.generate`](https://pkgdocs.julialang.org/v1/creating-packages/) or [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl). Unlinke a published Julia package, this  _project-package_ will remain not be registered in a Julia package registry, its code will be shared directly via git repository urls.  Developing the project in such a project-package has the following advantages:
   - Straightforward way to share  the code in the `src` folder among different project scripts and notebooks based on one shared environment via `using MyProject`.
   - Straightforward availability of Julia's  test and documentation functionality for the project.
   - Reproducibility due to dependencies recorded in the project environment (files `Project.toml` and `Manifest.toml`).

### New packages can evolve from the project code
For this purpose, optionally you can have a folder `packages` which contains other sub-packages which potentially can evolve into standalone, even registered packages. As [relative paths are recorded in Manifest.toml](https://github.com/JuliaLang/Pkg.jl/issues/1214), these are made available within the  project via `Pkg.develop(path="packages/MySubPackage")`.
Starting wit Julia 1.11, `Project.toml` can have a [`[sources]` section](https://pkgdocs.julialang.org/dev/toml-files/#The-[sources]-section) which can contain a relative path for a subpackage.
Either way, using this approach, the  whole project  tree including sub-packages  will stay relocateable.
   - This allows for easy start of low key package development. At a later stage, `MySubPackage` could be registered as a Julia package while still residing in the project tree, or even removed from the project tree without affecting  scripts depending on it -- once registered, the package can be added to the project environment via `Pkg.add` instead of `Pkg.develop`, or just removed from the `[sources]` section.
   
### Manifest or not ?
Should the `Manifest.toml` be checked into the project repository or not ? The answer is - your mileage may vary.

Pro Checking in the manifest file:
- Strong reproducibility of the computational results
- Starting with Julia 1.11, there can be different Manifest files for each Julia minor version (e.g. `Manifest-v1.11.toml`), checking in the respective manifests can allow to use different Julia versions.
- Subpackages in relative paths can only be found via the `Manifest.toml` (for Julia <1.11)

Pro not checking in the manifest file:
- Strong reproducibility is required when publishing results, not during development, where experimentation is ubiquitous
- Dependency version checking can be managed via the `[compat]` section in `Project.toml`
- With Julia <1.11, checking in the manifest file requires that all project collaborators use the same Julia version
- Subpackages in relative paths can be found via the `[sources]` section of Project.toml  (for Julia >=1.11)
- Successful tests with different dependency versions are a sign of robustness of the package code.  Diverging results with different Julia versions or different versions of dependencies hint on possible problems of the project code or the packages.
- Easy unit tests on different Julia versions

### Always start Julia from the package root
- When working with the project, always run julia from the package root with the package environment activated: `julia --project=.` 


### Activate the project environment in notebooks
Project specific Pluto notebooks would reside in a  `notebooks` subdirectory  and call  `Pkg.activate(joinpath(@__DIR__,".."))` in their respective Pkg cell to activate the `MyProject` environment.  As a consequence, Pluto's in-built package manager will be disabled and the project specific notebooks will share the `MyProject` environment and _cannot be shared independent from the `MyProject` tree_ (If independent sharing is desired, common project code can be collected into a package residing in `packages` and registered in a registry; registering `MyProject` itself as a package is not recommended.  -- More about this in another post).

### Consider using DrWatson.jl
You may use [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) for managing subdirectory access, simulation results and version tagging. By explicitely activating the project environment at the start of Julia or in the notebook Pkg cell, you can avoid  `@quickactivate` and  avoid putting `using DrWatson` into script files and notebooks for the sole purpose of activating the common environment. See also [this discussion](https://github.com/JuliaDynamics/DrWatson.jl/issues/261).


### A sample project tree
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

## Summary

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


~~~
<hr size="5" noshade>
~~~
__Update history__
- 2024-07-31: Julia 1.11
- 2023-04-24: Intermediate headers
- 2022-02-09: RSS
- 2021-12-02: The term "project" in this post corresponds to the term "application" in [package manager glossary](https://pkgdocs.julialang.org/v1/glossary/#Glossary).
- 2021-11-15: Initial version 


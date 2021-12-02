@def tags = ["julia"]

# Julia: Project Workflow

Initial version: 2021-11-15

Update 2021-12-02: The term "project" in this post corresponds to the term "application" in [package manager glossary](https://pkgdocs.julialang.org/v1/glossary/#Glossary).


Some ideas on basic julia workflow  are given  [here](/julia/basic-workflow).
For a larger project, structuring of the project code is essential for many reasons, some of them are:
- Different project scripts and Pluto notebooks may share some parts of the code, and you want to avoid [repeating yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).
- Modularization of the project code should facilitate maintainability and extendability.
- May be some of the code slowly turns into a package.
- You want to have unit testing available in the project.
- The whole project directory _still_ shall be shareable with collaborators in a reproducible way.

The following recommendations are partially inspired by B. Kaminski's post on  [project workflow](https://bkamins.github.io/julialang/2020/05/18/project-workflow.html) and  the  [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) package by G. Datseris.


- Generate the project directory itself as a package (named e.g. `MyProject`) using [`Pkg.generate`](https://pkgdocs.julialang.org/v1/creating-packages/) or [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl). This  _project-package_ will remain unregistered, its code will be shared directly via git repository urls.  Developing the project in such a project-package has the following advantages:
   - Straightforward way to share  the code in the `src` folder among different project scripts and notebooks based on one shared environment via `using MyProject`.
   - Straightforward availability of Julia's  test and documentation functionality for the project.

- Optionally have a folder `packages` which contains other sub-packages which potentially can evolve into standalone, registered packages.
  As [relative paths are recorded in Manifest.toml](https://github.com/JuliaLang/Pkg.jl/issues/1214), these are made available within the  project via `Pkg.develop(path="packages/MySubPackage")`. This way, the  whole project  tree including sub-packages  will stay relocateable.
   - This allows for easy start of low key package development. At a later stage, `MySubPackage` could be registered as a Julia package while still residing in the project tree, or even removed from the project tree without affecting  scripts depending on it -- once registered, the package can be added in to the project environment via `Pkg.add` instead of `Pkg.develop`.
   
   
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

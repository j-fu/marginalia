# {PKGNAME}.jl


## Initial remarks

This is the initial version of the  {PKGNAME} project.

### Running code

All scripts and notebook need to run in the environment of this project. For this purpose, they start with activating this environment and are not
relocateable.

#### After installation
After installing or updating the code, the project environment needs to be instantiated. For this purpose, run
```
$julia --project
julia> using Pkg
julia> Pkg.instantiate()
```
or
```
julia etc/instatiate.jl
```

#### Running notebooks
On can run the notebooks like
```
julia etc/runpluto.jl notebooks/demo-notebook.jl
```

### Adaptation
- Please check the LICENSE file and replace it by another license if you don't agree with it.
- Please check the `authors` entry in `Project.toml`
- Remove or replace demo scripts and notebooks
- Set up a git repo for sharing the code. All subdirectories and top level files in this initial version should be under version control
- Consider introducing  subdirectories for large simulation results which are not under version control due to their size
- Consider introducing further subdirectories to struture your project
- The project has  [DrWatson.jl](https://juliadynamics.github.io/DrWatson.jl/stable/) as dependency.
  This project structure is compatible to it with two exceptions:
  - It doesn't rely on `@quickactivate`.  It assumes  that the skills obtained by learning how to work with Julia environments are useful
  - Notebooks are assumed to be Pluto notebooks which can be  version controlled in straigtforward way, unlike Jupyter notebooks

### Initial file structure

```
{PKGNAME}/
├── src
│   └── {PKGNAME}.jl
├── docs
│   ├── make.jl
│   ├── Project.toml
│   └── src
│       └── index.md
├── LICENSE
├── notebooks
│   └── demo-notebook.jl
├── Project.toml
├── README.md
├── scripts
│   └── demo-script.jl
├── etc
│   ├── runpluto.jl
│   └── instantiate.jl
└── test
    └── runtests.jl
```
The essential role of these files is as follows:
- `Project.toml`: The project file describes the project on a high level. It lists packages used by the prokject together with version compatibility constraints  [documentation](https://pkgdocs.julialang.org/v1/toml-files/#Project-and-Manifest)
- `LICENSE`: License of the project. By default it is the MIT license
- `README.md`: This file
- `src`: Subdirectory for project specific code as part of the {PKGNAME} package representing the project.
- `test`: Unit tests for project code in `src`. Could include something from `scripts`, `notebooks`.
- `scripts`, `notebooks`: "Frontend" code for creating project results
- `papers`: "Wer schreibt, der bleibt" - besides of coding, you probably should publish your results...
- `docs`: Sources for the documentation created with `Documenter.jl`
- `etc`: Service code

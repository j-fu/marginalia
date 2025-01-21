@def tags = ["julia"]
@def rss_description = "Julia: Introductory material."
@def rss_pubdate = Date(2023, 4, 23)


# Julia: Introductory material
This is a collection of online references pointing at introductory material for the Julia language.If you look for further online resources, please ensure that they are for Julia 1.0 and newer. This is best achieved by looking for material not older than 2019.


\toc


## Installation
[juliaup](https://julialang.org/downloads/#install_julia) provides the most flexible way to install Julia and to switch between versions. Alternatively, install the latest stable version via the Julia [homepage](https://julialang.org/downloads/#current_stable_release). Julia devs [recommend not to use](https://julialang.org/downloads/#please_do_not_use_the_version_of_julia_shipped_by_unix_package_managers) the Julia versions provided from other sources (like Homebrew, various Linux package managers). 

## Learning
### Resources curated by the Julia development team.
  - [Julia documentation](https://docs.julialang.org/en/v1/)
     - [Getting started](https://docs.julialang.org/en/v1/manual/getting-started/)
     - Noteworthy differences from [Matlab](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-MATLAB-1), [R](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-R-1), [Python](https://docs.julialang.org/en/v1/manual/noteworthy-differences/?highlight=matlab#Noteworthy-differences-from-Python-1), [C/C++](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-C/C)
  - [Curated learning resources](https://julialang.org/learning/)
  - [Books](https://julialang.org/learning/books/)
  - Julia is evolving. New versions in the 1.x range introduce many important additions and non-breaking changes. Many important Julia packages require at least the current long term service (LTS) version 1.10. 
    - Julia version highlights: [1.5](https://julialang.org/blog/2020/08/julia-1.5-highlights/), [1.6](https://julialang.org/blog/2021/03/julia-1.6-highlights/), [1.7](https://julialang.org/blog/2021/11/julia-1.7-highlights/), [1.8](https://julialang.org/blog/2022/08/julia-1.8-highlights/), [1.9](https://julialang.org/blog/2023/04/julia-1.9-highlights/), [1.10](https://julialang.org/blog/2023/12/julia-1.10-highlights/), [1.11](https://julialang.org/blog/2024/10/julia-1.11-highlights/)
    
    - [Why Julia 2.0 Isn’t Coming Anytime Soon](https://towardsdatascience.com/why-julia-2-0-isnt-coming-anytime-soon-and-why-that-is-a-good-thing-641ae3d2a177)
### More learning resources 
  - The book [Introduction to Applied Linear Algebra – Vectors, Matrices, and Least Squares](https://web.stanford.edu/~boyd/vmls/) by Stephen Boyd and Lieven Vandenberghe has a [Julia companion](http://vmls-book.stanford.edu/vmls-julia-companion.pdf)
  - [Cheat Sheet](https://juliadocs.github.io/Julia-Cheat-Sheet/)
  - [Matlab-Julia-Python cheat sheet](https://cheatsheets.quantecon.org/)
  - [QuantEcon](https://julia.quantecon.org/index_toc.html) tutorial with focus on economics and statistics
  - [Julia for Talented Amateurs](https://www.youtube.com/c/juliafortalentedamateurs/videos): Collection of video tutorials for many different aspects of Julia
  - [WikiBook](https://en.wikibooks.org/wiki/Introducing_Julia)

## Introductory material from my TU Berlin courses  and other talks (videos + Pluto notebooks)
- [My teaching homepage](https://www.wias-berlin.de/people/fuhrmann/teaching/). Generally, the material from the first couple of weeks can serve as an introduction to Julia. Material is provided in form of Pluto notebooks (versions rendered html and pdf are linked as well). While video recordings may have been "recycled" from previous years, the notebook Julia files linked are updated to the corresponding current stable Julia version at the moment of the start of the semester.
- [The Julia programming language - an overview](https://av.tib.eu/media/57515). Talk at [Leibniz MMS Days 2022](https://www.wias-berlin.de/workshops/MMSDays22/).

## Editing
- [Visual Studio Code extension](https://www.julia-vscode.org/docs/latest/gettingstarted/)
- [Pluto notebooks](https://plutojl.org); 
    How to install Julia and Pluto: [MIT course video](https://www.youtube.com/watch?v=OOjKEgbt8AI)
- [Emacs support](https://github.com/JuliaEditorSupport/julia-emacs)
- [zed support](https://zed.dev/docs/languages/julia)
~~~
<hr size="5" noshade>
~~~

__Update history__
- 2025-01-21: Julia 1.11, update some links, streamline reference to my courses
- 2024-10-02: Julia 1.10, upvote juliaup
- 2023-10-17: Julia as a second language, semester info

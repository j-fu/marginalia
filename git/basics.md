@def title = "Marginalia -- Git basics"
@def tags = ["git"]
# Git
2021-11-29

\toc
## Version control

[Version   control](https://en.wikipedia.org/wiki/Version_control)  in software development consists  in recording all changes  in the source  code with the help of a *version control system* (VCS), a collection of software tools which manage versioning and collaboration in software development.

Version control allows  to track all changes in a  software system, to manage different  development branches, to organize  the collaboration of developers.  In the case  of research software, version  control is becoming an indispensible tool to maintain Good Scientific Practice.





### Centralized version control systems

Centralized version control systems like [subversion (svn)](https://subversion.apache.org/) work based on the client-server priciple. Developers check out working copies from a central server, and commit the changes back to that server after work has been finished.


### Distributed version control systems
[Distributed version control systems](https://en.wikipedia.org/wiki/Distributed_version_control)
 like [git](https://git-scm.com/) and [mercurial](https://www.mercurial-scm.org/) are organized after the peer-to-peer principle. Instead of a working copy containing only a current version, users maintain *clones* of repositories, each of them containing the full history of the code. While it is possible to emulate the centralized model with this approach, the additional flexibility of this model has many [advantages](https://rhodecode.com/blog/62/why-embrace-distributed-version-control-systems).


## Git

Git  was intiated by Linus Torvalds and as of now (2021) became the de-facto standard for source code management systems.
~~~
    <center>
    <img src="https://imgs.xkcd.com/comics/git.png" style="width: 50%;"><br>
    from <a href="https://xkcd.com/1597/"> xkcd </a>
    </center>
~~~



### Git from the command line
Its origin as a tool for hardcore coders brings along a command line interface which is not easy to learn.
Here are some resources besides the [git homepagee](https://git-scm.com/) with a number of [external resources](https://git-scm.com/doc/ext):

 
- It is often stated that understanding git is significantly eased by understanding the way it organizes data. Here the basic idea is that all the different stages developed sequentially or in parallel of  a program source can be organized as a Directed Acyclic Graph (DAG).  This is what git does, and [Git for Computer Scientists](https://eagain.net/articles/git-for-computer-scientists/) draws on this idea.

- [git - the simple guide](https://rogerdudler.github.io/git-guide/) "just a simple guide for getting started with git. no deep shit ;)"

- [Backlog Git Tutorial](https://backlog.com/git-tutorial/) "If you are completely new to Git, you can start exploring the "Getting Started" section for an introduction"

- [Software Carpentry](https://swcarpentry.github.io/git-novice/) "Version Control with Git"



For collaborative development, it is worth to dig down the concept of _branches_.


### Graphical user interfaces to git 
In order to avoid or to minimize the interaction with git via the command line, graphical user interface tools are [available](https://en.wikipedia.org/wiki/Comparison_of_Git_GUIs).
A good quality criterion for choosing such a tool is its ability to visualize the underlying DAG.

- Windwows, Mac: [sourcetree](https://www.sourcetreeapp.com/)
- On Linux, there are a number of tools. Among them are: 
   - [git-cola, git-dag](https://git-cola.github.io/)
   - [qgit](https://github.com/tibirna/qgit)
  It should be possible to install them wia the package manager of your distribution.
  
### Git interaction from editing environments

Modern editors and editing environments like [Visual Studio Code](https://code.visualstudio.com/docs/editor/versioncontrol#_git-support)
have a git extension supporting basic workflow.

### Repository hosting and collaboration platforms

At the current stage, the decentralized model of development is to a significant extent thwarted by the availability of platforms like [github](https://github.com) and [gitlab](https://gitlab.org)  which in addition to hosting provide important additional features like Continous Integration (server based automatic software tests), issue discussions, easy support for standard workflows, wiki pages and more.

These platforms introduced the useful concept of [pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) aka [merge requests](https://docs.gitlab.com/ee/user/project/merge_requests/).

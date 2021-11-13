# Version control with mercurial
(2014-10-30, update 2016-09-14)

The main  open source choices for  source code  version control systems (VCS)  are
the centralized  VCS
[CVS](http://savannah.nongnu.org/projects/cvs) and
subversion                     [(svn)](http://subversion.apache.org/),
and the distributed VCS
[git](http://git-scm.com/)                and                Mercurial
[(hg)](http://mercurial-scm.org/).


I am taking sides with mercurial, as  it is distributed and has a more
intuitive command line interface and better portability than git.

<!-- more --> 


[Linus Torvalds at Google in 2007:](http://www.youtube.com/watch?v=4XpnKHJAok8)
"Subversion  has  been  the  most pointless  project  ever  started...
Subversion used  to say, 'CVS done  right.' With that slogan  there is
nowhere you can go.  There is no way to do CVS right."  Probably he is
not  completely wrong.   As  from this choice only git  and  mercurial are  distributed
version control  systems, the choice  is between them, unless  you are
using  some  features of  svn  they  don't  provide (e.g.  checking  out
subdirectories).


Please be aware that  git is more widespread and  it seems that for this reason
there are more tools on top of it. Some more colloquial take on the comparison between
them you find
[here](http://importantshock.wordpress.com/2008/08/07/git-vs-mercurial/).

## Introduction


- [Mercurial home page](http://mercurial-scm.org/)
- [Quick start](http://mercurial-scm.org/wiki/QuickStart)
- [Tutorial](http://mercurial-scm.org/wiki/Tutorial)
- [Kickstart](http://mercurial.aragost.com/kick-start/en/) ... seems to be
   so far the best of these tutorials.

Mercurial  (hg) is  implemented  in  python and  works  on  most modern
operating systems (Linux, Windows, Mac).


Before starting, create a file named `.hgrc` in your home directory
containing
```
[ui]
username = Ann User <ann.user@example.com>
```

In  Mercurial,  unlike in  subversion  there  is no  division  between
"sandbox" and "repository".  Any instance you work with contains both.
So  in every  "sandbox" there  is a  hidden "repository"  (in the  .hg
subdirectory of the top level direcrory).

You can  clone any  given instance. Clone  commands can  using several
kinds of access


    hg clone http://some.host.atyourinstitute.de:port directoy_to_be_created
	hg clone file://some_directory_on_your_disc directoy_to_be_created
	hg clone ssh://some_directory_on_your_remote directoy_to_be_created

There is no a prioi defined master repository.  All descendants of the
initial repository have the same  rights and allow transfer operations
between any  of them.  Therefore it  is possible that two  people work
together using `hg` and after finishing their joint work, they release
it to  the others  in the project.   This is believed  to be  the main
advantage  of   distributed  version   control  in  opposite   to  the
centralized model represented by `svn`.

## Installation

If the command `hg` is not available on your system, install mercurial
using your favorite package manager.


## Basic commands 

- `hg help`:   Print help information
- `hg commit`:   Check  in changes *locally* i.e. this does not affect  the remote  repository
- `hg push  `: transfer all recent changes to the remote repository 
- `hg pull  `: gets actual changes from the remote repository the hidden local repository
- `hg update`: update the local sandbox from the local repository
- `hg merge `: brings changes together
- `hg add   `: adds files
- `hg rm    `: deletes files
- `hg forget`: forgets unintentionally added files
- `hg revert`: re-establishes last commited revision
- `hg mv    `: moves/renames files
- `hg init  `: set up a new repository 
- `hg serve  `: set up a mini webserver accessible via `http://localhost:8000`
  which allows to browse the repository and all versions


Yes, there are also branches.



## Master repository workflow

The   structure    of   Mercurial    allows   to    define   different
[workflow  patterns](http://mercurial-scm.org/wiki/Workflows) ([git version](http://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows)).   The
simplest and most obvious  one for people coming from CVS  or svn is a
workflow around one central master repository. 



The pattern goes as follows:

  1. Clone the master repository and change into directory.
```
  hg clone url localdir
  cd localdir
```
  2. Pull the latest changes from the master:
```
  hg pull
  hg update
  hg merge
```
  3.  Modify/merge the  code.  You can   commit intermediate  changes
  without affecting the master  repository with
```
   hg commit
```
  This command asks for a short commit message.
  To add new files to the VCS, before committing use
```
   hg add filename
```
  4. Test the code. If changes are necessary, repeat step 3.
  5. Repeat step 2 to be sure to have the latest updates.
  6. Test again, to be sure that the most recent changes form
     the master are compatible with your
	 work.
  7. Push the changes to the remote repository
```
  hg push
```

### Notification

The  maintainer  of  the  master  repository  has  the  possibility  to
configure email notifications.






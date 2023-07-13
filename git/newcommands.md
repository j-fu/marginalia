---
fontsize: 10pt
title: Some (not so) new command line utilities
author: Jürgen Fuhrmann
date: WIAS coffee lecture, 2023-04-28
transition: slide
slideNumer: true
...


Where is my file? 

What was the name of the file where I wrote that phrase? 

How can I keep track of my git repository?

How do I convert my markdown text to LaTeX?

Stay up-to-date with tools written in Haskell, Rust an Go which complement the classical UNIX command line canon.

# fzf

## aka "Where is my file ?"

-  fast and powerful command-line fuzzy finder
-  helps you quickly search for files, directories and other items 
-  supports integration with other command-line tools, such as bash, git, ag, and fd

# fzf with bash completion

You want to run 
```
$ command myfile
```
but `myfile` is deep in your directory hierarchy.

- enter `command` and `**<TAB>`
- choose file once found, press `enter`
- this will run 

```
$ command somewhere/deep/myfile
```

# rg

aka "What was the name of the file where I wrote that phrase?"

- search tool for the command line, alternative to the traditional grep command. 
- regular expressions and is optimized for speed, making it ideal for searching large files and directories.
- support for search and replace operations, file type filtering

# rg usage

```
$ find . -name "*.md" | xargs grep myphrase
```
vs
```
$ rg -tmd myphrase
```
... and it is much faster

# gitui

- terminal-based graphical user interface for Git
- easy-to-use interface for common Git operations like commit, push, and pull
- advanced features like branch management and stash management


# pandoc

- command-line utility for converting files from one format to another, such as Markdown to HTML, LaTeX to Word, or EPUB to PDF. 
- can also be used as a library in other programs or scripts to automate document conversion tasks

<img src="pandoc-cartoon.svgz" width="20%"></img>

# Acknowledgement

- ChatGPT for creating intial slide texts
- Discussion on this is intended for the next coffee lecture




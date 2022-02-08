# Just another intro to git.

## Software development creates a DAG

Incovenient practice: mycode-v5_corrected. etc.
Map process onto mathematial structure

- Nodes: code versions
- Edges: developer actions (Commits ?)
- Time direction -> arrows, not going bac
=> Directed Acyclic Graph 

## Naming versions nodes ? 
We need to name versions nevertheless in order to be able to refer to them 
programmatically or as humans

Hashes!
A hash function maps data to a finite length bit representation
usually represented as a hexadecimal number.
Hashes allow to find out if some data have been changed, they also can be used
for "content addressing"
So we have an automatic naming scheme.

## Who can remember these names ?
-> Tags

## Where to store information 
.git subdirectory
Project has two types of files:
- untracked (left alone by git)
- tracked (controlled by git)

Tracked files are manipulated by git commands. 
These have been thought out by Linus Torvalds  during one evening  with the help of some beers (legend...)

https://gitbetter.substack.com/p/a-very-basic-intro-of-git




## QQQ

- What is a commit ?  Edge or node ?
- What exactly is hashed ? UUID or content ?
- What exactly is stored ? diffs vs changed files

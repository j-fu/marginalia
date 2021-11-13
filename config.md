<!--
Add here global page variables to use throughout your website.
-->
+++
author = "Jürgen Fuhrmann"
mintoclevel = 2

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/", "QUARRY", "QUARRY.md"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "Marginalia"
website_descr = "Remarks on computing & stuff"
website_url   = "https://j-fu.github.io/marginalia/"
prepath = "marginalia"
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\RR}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}

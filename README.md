# Homepage

This is a git repository for my homepage, currently at
(http://ccs.neu.edu/home/milo).

## CSS
I'm using SASS as a preprocessor for CSS.

## HTML

I'm using Racket to generate HTML pages. `lib.rkt` contains macros and
functions to build the HTML tree as an s-expression (more specifically
an "x-expression") which is then easily converted into HTML. The
actual website content is defined in `site.rkt`. `site.rkt` uses the
`at-exp` reader extension to allow inline prose more easily.

## JS

I'm not using any preprocessors or compilers for JavaScript, although
that should probably change in the future. Possible options:

- Learn Purescript
- Use `js_of_ocaml`
- Generate part of the JavaScript in Racket

Someone gave me the idea to implement a virtual DOM to allow
navigation without reloading the page. I think that using Racket to
generate JS code would be an interesting way to accomplish this, but
it's not my top priority. For now, the small JavaScript file works
fine.

#lang at-exp racket
(require "lib.rkt"
         syntax/parse/define
         (for-syntax racket/syntax))

;; -------------------------------
;; helpers

(define (git-url who [what ""])
  (format "https://github.com/~a/~a" who what))

(define ((a url title) text)
  `(a ([href ,url] [title ,title] [target "_blank"]) ,text))

;; --------------------------------
;; constants

(define GOOGLE-FONTS-URL
  "https://fonts.googleapis.com/css?family=Roboto|Work+Sans")

(define CV-PATH
  "resume-milo-turner.pdf")

(define LINKEDIN-URL
  "https://www.linkedin.com/in/milo-turner-0741a8120/")

;; -------------------------------
;; home

(define-nav index "Home"
  (define cv    (a CV-PATH "CV - Milo Turner"))
  (define mygit (a (git-url "iitalics") "Milo Turner (iitalics)"))
  (define rakt  (a "https://racket-lang.org" "Racket"))
  (define luci  (a (git-url "caseyz" "lucid") "Lucid VCS"))
  (define forth (a "http://wiki.c2.com/?ForthLanguage" "Forth - C2 Wiki"))
  (define taste (a "http://www.paulgraham.com/taste.html" "Taste For Makers (Paul Graham)"))
  #:page

  @h2{About}

  @p{ Hi! I'm an undergraduate student studying Computer Science at Northeastern
      University. I've been programming since I was young, so I'm very passionate about
      computer science, especially compilers and type systems. }

  @p{ I'm an open-source software enthusiast, and I'm often working on personal projects
      or contributing to projects on GitHub. Check out my @,(mygit "GitHub") or my @,(cv
      "CV") to see what I've been working on recently. }

  @p{ I grew up on Maui, Hawaii, I have a twin sister living in Sydney, and
      an older sister attending school on Oahu. I've studied classical piano for a long
      time, and my favorite composer is Alexander Scriabin. }

  @h2{Musings}

  @p{ As a proponent of functional programming, I enjoy programming in OCaml, and hacking
      on @,(rakt "Racket"). I'm glad that more common languages like C++ and Java have adopted many
      useful functional ideas. The spirit of Lisp lives on! }

  @p{ As much as I love functions, I have a soft-spot for low-level hacking in C and also
      @,(forth "Forth"). I'm grateful to have worked under Mitch Bradley, who taught me a
      lot about Forth, but more generally about @,(taste "taste"): what it means for a
      design to be simple, small, and elegant. }

)

;; -------------------------------
;; contact

(define-nav contact "Contact"
  (define-simple-macro (entries {~seq name val} ...)
    (cons 'p (append* `([(strong ,name) ": " ,val (br)] ...))))
  #:page
  ,(entries "Phone"      "(808) 280 0766"
            "Email"      "milo@ccs.neu.edu"
            "Location"   "Boston, MA (Northeastern University)"))

;; -------------------------------
;; projects

(define-nav projs "Projects"
  (define-simple-macro (define-project x name url
                         {~or {~and #:left  {~parse left? #'#t}}
                              {~and #:right {~parse left? #'#f}}}
                         {~optional {~seq #:lang lang} ; TODO: insert language nexto
                                                       ; to project title
                                    #:defaults ([lang ""])}
                         pre-body ... xexpr)
    #:with this (format-id #'x "this")
    #:with title-class (if (syntax-e #'left?) #'"title" #'"title title-right")
    #:with icon #'(a ([href ,url] [class ,(format "icon icon-~a" 'x)]) "")
    #:with content #'(div ([class "content"])
                       (a ([href ,url] [class title-class]) ,name)
                       xexpr)
    #:with project-div (if (syntax-e #'left?)
                           #'`(div ([class "project"]) icon content)
                           #'`(div ([class "project"]) content icon))
    (define x
      (let ()
        (define this `(em ,name))
        pre-body ...
        project-div)))

  (define-project nanocaml "Nanocaml" (git-url "iitalics" "nanocaml") #:left
    #:lang "OCaml"
    (define naps (a "http://nanopass.org/" "Nanopass Framework"))
    @p{ @,this is an OCaml preprocessor extension that empowers compiler writers to create
        many intermediate languages and passes. Based on @,(naps "Nanopass"), Nanocaml
        analyzes data definitions to generate recursive functions. })

  (define-project opal "Opal" (git-url "iitalics" "opal") #:right
    #:lang "C++"
    @p{ @,this is a programming language with C-like syntax, designed to experiment with
        an interface system that is more permissive than Java interfaces or Haskell
        typeclasses. Includes additional features like pattern matching and type
        inference. })

  (define-project lucid "Lucid" (git-url "caseyz" "lucid") #:left
    #:lang "C++"
    (define org (a "https://orgmode.org/" "Org mode for Emacs"))
    @p{ @,this is an experimental version control system, similar to Git and Darcs. It uses
        "patch commutation" as a mathematical basis for merge and cherry-pick
        operations. It also has a text-based frontend designed to integrate with @,(org
        "org-mode") within the editor Emacs. })

  (define-project home "This Website" (git-url "iitalics" "Personal-homepage") #:right
    #:lang "Racket, SASS, JS"
    @p{ This page is built using SASS to generate CSS, and Racket to generate HTML from
        s-expressions. I try to make everything open-source, so feel free to check out how
        this very site works! })

  #:page
  @h2{Projects}
  @,nanocaml
  @,opal
  @h2{Works in Progress}
  @,lucid
  @,home
  )

;; -------------------------------------------------------------

(define-nav cv "CV" CV-PATH) ; note: NOT ext-link
(define-nav +github "GitHub" #:ext-link (git-url "iitalics"))
(define-nav +linkedin "LinkedIn" #:ext-link LINKEDIN-URL)

(parameterize
    ([current-nav     (list index contact cv projs +github +linkedin)]
     [current-scripts (list "dance.js")]
     [current-css     (list GOOGLE-FONTS-URL "style.css")]
     [current-output-dir "www"])
  (generate-pages))

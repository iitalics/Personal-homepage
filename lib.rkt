#lang racket/base
(require xml syntax/parse/define
         (for-syntax racket/base))
(provide (all-from-out xml)
         (all-defined-out))

(struct nav-item
  [title url])

(struct page nav-item
  [article-fn])

(struct ext-link nav-item
  [])

(define current-name
  (make-parameter "Milo Turner"))

(define current-nav
  (make-parameter '()))

(define current-css
  (make-parameter '()))

(define current-scripts
  (make-parameter '()))

(define (page->xexpr page)

  (define head-sec
    `(head
      (title ,(nav-item-title page))
      (meta ([charset "UTF-8"]))
      (meta ([name "viewport"] [content "width=device-width, initial-scale=1.0"]))
      ,@(for/list ([s (in-list (current-css))])
          `(link ([rel "stylesheet"] [href ,s])))
      ,@(for/list ([s (in-list (current-scripts))])
          `(script ([type "text/javascript"] [src ,s]) ""))))

  (define nav-sec
    `(nav
      ,@(for/list ([ni (in-list (current-nav))])
          (define cn
            (cond [(equal? (nav-item-title ni)
                           (nav-item-title page)) "cur"]
                  [(ext-link? ni) "ext"]
                  [else ""]))
          (define attrs
            (list* `[href ,(nav-item-url ni)]
                   `[class ,cn]
                   (if (page? ni) `() `([target "_blank"]))))
          `(a ,attrs
              ,(nav-item-title ni)))))

  (define dance
    `(span ([id "dance"])))

  (define body-sec
    `(body
      (div ([class "container"])
           (h1 ,(current-name))
           ,nav-sec
           ,((page-article-fn page))
           ,dance)))

  `(html ,head-sec ,body-sec))

(define current-output-dir
  (make-parameter "."))

(define (generate-pages [pgs (filter page? (current-nav))])
  (define out (current-output-port))
  (for ([pg (in-list pgs)])
    (with-output-to-file (build-path (current-output-dir)
                                     (nav-item-url pg))
      #:exists 'replace
      (λ ()
        (fprintf out "+ generating: ~v\n" (nav-item-url pg))
        (write-xexpr (page->xexpr pg))))))

(define-syntax define-nav
  (syntax-parser
    [(_ x:id title url)
     #'(define x (nav-item title url))]
    [(_ x:id title #:ext-link url)
     #'(define x (ext-link title url))]
    [(_ x:id title pre-body ... #:page xexpr ...)
     #:with url (format "~a.html" (syntax-e #'x))
     #'(define x (page title 'url (λ () pre-body ... `(article xexpr ...))))]))

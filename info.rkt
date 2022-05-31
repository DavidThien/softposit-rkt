#lang info
(define name "softposit-rkt")
(define install-collection "install.rkt")
(define compile-omit-files '("install.rkt"))
(define move-foreign-libs '())
(define deps '("math-lib"
               "base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("softposit-rkt.scrbl")))
(define pkg-desc "Racket bindings for softposit")
(define version "1.0")
(define pkg-authors '("David Thien"))

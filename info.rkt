#lang info
(define name "softposit-rkt")
(define pre-install-collection "install.rkt")
(define compile-omit-files '("install.rkt"))
(define move-foreign-libs '("libsoftposit.so"))
(define deps '("math-lib"
               "base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/softposit-rkt.scrbl")))
(define pkg-desc "Racket bindings for softposit")
(define version "1.0")
(define pkg-authors '(David Thien))

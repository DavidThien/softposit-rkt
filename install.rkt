#lang racket/base

(require racket/system)
(require racket/list)
(require setup/dirs)

(provide installer)

(define (installer collections-top-path this-collection-path user-specific?)
  (define (call-and-wait command)
    (define out (process command))
    ((fifth out) 'wait))

  ;; Despite the name, this directory contains a Makefile that works on many platforms
  (define build-location (build-path this-collection-path "SoftPosit/build/Linux-x86_64-GCC/"))
  (define lib-name (path-replace-extension "libsoftposit.so" (system-type 'so-suffix)))
  (define lib-location (build-path (if user-specific? (find-user-lib-dir) (find-lib-dir)) lib-name))

  ;; Compile the softposit C library and wait for the make command to finish
  (call-and-wait (string-append "make -C " (path->string build-location) " SOFTPOSIT_OPTS=\"$(SOFTPOSIT_OPTS) OPTIMISATION=\"-O2 -march=native\" -fPIC\""))
  (call-and-wait (string-append "gcc " (path->string build-location) "*.o -shared -o " (path->string lib-location)))
  (call-and-wait (string-append "make clean -C " (path->string build-location))))

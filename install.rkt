#lang racket/base

(require racket/system)
(require racket/list)
(require setup/dirs)
(require racket/file)

(provide installer)

(define (installer collections-top-path this-collection-path user-specific?)
  (define (call-and-wait command)
    (define out (process command))
    ((fifth out) 'wait)
    (unless (eq? ((fifth out) 'status) 'done-ok)
      (for ([line (in-lines (first out))])
        (displayln line (current-output-port)))
      (for ([line (in-lines (fourth out))])
        (displayln line (current-error-port)))
      (error 'softposit-rkt "Error running ~a" command)))

  ;; Despite the name, this directory contains a Makefile that works on many platforms
  (define build-location (build-path this-collection-path "SoftPosit/build/Linux-x86_64-GCC/"))
  (define lib-name (path-replace-extension "libsoftposit.so" (system-type 'so-suffix)))
  (define lib-dir (if user-specific? (find-user-lib-dir) (find-lib-dir)))
  (define lib-location (build-path lib-dir lib-name))

  ;; Compile the softposit C library and wait for the make command to finish
  (make-directory* lib-dir)
  (call-and-wait (string-append "make -C " (path->string build-location) " SOFTPOSIT_OPTS=\"$(SOFTPOSIT_OPTS) -fPIC\" OPTIMISATION=\"-O2 -march=native\""))
  (call-and-wait (string-append "gcc " (path->string build-location) "*.o -shared -o " (path->string lib-location)))
  (call-and-wait (string-append "make clean -C " (path->string build-location))))

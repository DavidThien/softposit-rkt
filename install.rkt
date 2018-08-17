#lang racket/base

(require racket/system)
(require racket/list)

(provide pre-installer)

(define (pre-installer collections-top-path this-collection-path)
  (define (call-and-wait command)
    (define out (process command))
    ;; TODO: This is just for testing purposes
    (for ([i (in-naturals)]
          #:break (not (eq? ((fifth out) 'status) 'running)))
      void)
    (println (read (car out))))

  (define build-location (build-path this-collection-path "SoftPosit/build/Linux-x86_64-GCC/"))
  (println build-location)
  (define lib-location (build-path this-collection-path "libsoftposit.so"))
  (println lib-location)

  ;; Compile the softposit C library and wait for the make command to finish
  (call-and-wait (string-append "make -C " (path->string build-location) " SOFTPOSIT_OPTS=\"$(SOFTPOSIT_OPTS) -fPIC\""))
  (call-and-wait (string-append "gcc " (path->string build-location) "*.o -shared -o " (path->string lib-location)))
  (call-and-wait (string-append "make clean -C " (path->string build-location))))

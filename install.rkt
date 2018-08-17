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
      void))

  (define build-location (build-path this-collection-path "SoftPosit/build/Linux-x86_64-GCC/"))
  (define lib-location (build-path this-collection-path "libsoftposit.so"))
  (define softposit-location (build-path this-collection-path "SoftPosit"))
  (println (path->string softposit-location))
  (println (string-append "git -C " (path->string softposit-location) " submodule init"))

  ;; If the SoftPosit path is empty, then git submodules weren't initialized
  (when (= 0 (length (directory-list softposit-location)))
    (begin
      (call-and-wait (string-append "git -C " (path->string softposit-location) " submodule init"))
      (call-and-wait (string-append "git -C " (path->string softposit-location) " submodule update"))))

  ;; Compile the softposit C library and wait for the make command to finish
  (call-and-wait (string-append "make -C " (path->string build-location) " SOFTPOSIT_OPTS=\"$(SOFTPOSIT_OPTS) -fPIC\""))
  (call-and-wait (string-append "gcc " (path->string build-location) "*.o -shared -o " (path->string lib-location)))
  (call-and-wait (string-append "make clean -C " (path->string build-location))))

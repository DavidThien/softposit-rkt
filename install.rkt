#lang racket/base

(require racket/system)
(require racket/list)

(define (call-and-wait command)
  (define out (process command))
  ;; TODO: This is just for testing purposes
  (for ([i (in-naturals)]
        #:break (not (eq? ((fifth out) 'status) 'running)))
    void))

;; Compile the softposit C library and wait for the make command to finish
(call-and-wait "make -C SoftPosit/build/Linux-x86_64-GCC SOFTPOSIT_OPTS=\"$(SOFTPOSIT_OPTS) -fPIC\"")
(call-and-wait "gcc SoftPosit/build/Linux-x86_64-Gcc/*.o -shared -o libsoftposit.so")

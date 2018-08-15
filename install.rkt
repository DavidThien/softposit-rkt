#lang racket/base

(require racket/system)

(define (call-and-wait command)
  (define out (process command))
  (subprocess-wait (third out)))

;; Compile the softposit C library and wait for the make command to finish
(call-and-wait "make -C SoftPosit/build/Linux-x86_64-GCC SOFTPOSIT_OPTS=\"$(SOFTPOSIT_OPTS) -fPIC\"")
(call-and-wait "gcc *.o -shared -o ../../../softposit.so")

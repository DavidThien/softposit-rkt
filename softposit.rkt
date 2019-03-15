#lang racket

(require ffi/unsafe)
(require math/bigfloat)
;; This file makes racket bindings for all the posit functions

;; Define all types. Note that this file assumes that the softposit code was compiled
;; with SOFTPOSIT_EXACT undefined
(provide _posit8 _posit16 _posit32 _posit64 _posit128
         posit8? posit16? posit32? posit64? posit128?
         _quire8 _quire16 _quire32
         quire8? quire16? quire32?
         random-posit8 random-posit16 random-posit32 random-posit64 random-posit128
         random-quire8 random-quire16 random-quire32
         posit8-inf posit16-inf posit32-inf posit64-inf posit128-inf
         uint32->posit8 uint32->posit16 uint32->posit32 uint64->posit8 uint64->posit16 uint64->posit32
         int32->posit8 int32->posit16 int32->posit32 int64->posit8 int64->posit16 int64->posit32
         posit8->uint32 posit8->uint64 posit8->int32 posit8->int64
         posit8->posit16 posit8->posit32
         posit8-round-to-int posit8-add posit8-sub posit8-mul posit8-mulAdd posit8-div posit8-sqrt posit8-neg
         posit8= posit8<= posit8< posit8>= posit8>
         create-quire8 create-quire16 create-quire32
         quire8-fdp-add quire8-fdp-sub quire8->posit8
         posit8->double double->posit8
         posit16->uint32 posit16->uint64 posit16->int32 posit16->int64
         posit16->posit8 posit16->posit32
         posit16-round-to-int posit16-add posit16-sub posit16-mul posit16-mulAdd posit16-div posit16-sqrt posit16-neg
         posit16= posit16<= posit16< posit16>= posit16>
         quire16-fdp-add quire16-fdp-sub quire16->posit16
         quire16-twos-complement
         posit16->double float->posit16 double->posit16
         posit32->uint32 posit32->uint64 posit32->int32 posit32->int64
         posit32->posit8 posit32->posit16
         posit32-round-to-int posit32-add posit32-sub posit32-mul posit32-mulAdd posit32-div posit32-sqrt posit32-neg
         posit32= posit32<= posit32< posit32>= posit32>
         quire32-fdp-add quire32-fdp-sub quire32->posit32
         quire32-twos-complement
         posit32->double float->posit32 double->posit32
         posit8->quire8 posit16->quire16 posit32->quire32 
         double->quire8 double->quire16 double->quire32
         quire8->double quire16->double quire32->double
         posit8->ordinal posit16->ordinal posit32->ordinal
         ordinal->posit8 ordinal->posit16 ordinal->posit32)

(define-cstruct _posit8 ([v _uint8]) #:malloc-mode 'atomic-interior)
(define-cstruct _posit16 ([v _uint16]) #:malloc-mode 'atomic-interior)
(define-cstruct _posit32 ([v _uint32]) #:malloc-mode 'atomic-interior)
(define-cstruct _posit64 ([v _uint64]) #:malloc-mode 'atomic-interior)
(define-cstruct _posit128 ([v (make-array-type _uint64 2)]) #:malloc-mode 'atomic-interior)

(define-cstruct _quire8 ([v _uint32]) #:malloc-mode 'atomic-interior)
(define-cstruct _quire16 ([v (make-array-type _uint64 2)]) #:malloc-mode 'atomic-interior)
(define-cstruct _quire32 ([v (make-array-type _uint64 8)]) #:malloc-mode 'atomic-interior)

(define (random-bits b [n 0])
  (if (= b 0)
    n
    (random-bits (sub1 b) (+ (arithmetic-shift n 1) (random 2)))))

(define (random-posit8)
  (define v (random-bits 8))
  (make-posit8 v))

(define (random-posit16)
  (define v (random-bits 16))
  (make-posit16 v))

(define (random-posit32)
  (define v (random-bits 32))
  (make-posit32 v))

(define (random-posit64)
  (define v (random-bits 64))
  (make-posit64 v))

(define (random-posit128)
  (define v (for/list ([_ (range 2)])
              (random-bits 64)))
  (make-posit128 (list->cblock v _uint64)))

(define (random-quire8)
  (define v (random-bits 32))
  (make-quire8 (list->cblock (list v) _uint32)))

(define (random-quire16)
  (define v (for/list ([_ (range 2)])
              (random-bits 64)))
  (make-quire16 (list->cblock v _uint64)))

(define (random-quire32)
  (define v (for/list ([_ (range 8)])
              (random-bits 64)))
  (make-quire32 (list->cblock v _uint64)))

(define (posit8-inf)
  (make-posit8 (expt 2 7)))

(define (posit16-inf)
  (make-posit16 (expt 2 15)))

(define (posit32-inf)
  (make-posit32 (expt 2 31)))

(define (posit64-inf)
  (make-posit64 (expt 2 63)))

(define (posit128-inf)
  (make-posit128 (list->cblock (list (exp 2 63) (exp 2 63)) _uint64)))

(define uint32->posit8 (get-ffi-obj "ui32_to_p8" "libsoftposit" (_fun _uint32 -> _posit8)))
(define uint32->posit16 (get-ffi-obj "ui32_to_p16" "libsoftposit" (_fun _uint32 -> _posit16)))
(define uint32->posit32 (get-ffi-obj "ui32_to_p32" "libsoftposit" (_fun _uint32 -> _posit32)))
(define uint64->posit8 (get-ffi-obj "ui64_to_p8" "libsoftposit" (_fun _uint64 -> _posit8)))
(define uint64->posit16 (get-ffi-obj "ui64_to_p16" "libsoftposit" (_fun _uint64 -> _posit16)))
(define uint64->posit32 (get-ffi-obj "ui64_to_p32" "libsoftposit" (_fun _uint64 -> _posit32)))

(define int32->posit8 (get-ffi-obj "i32_to_p8" "libsoftposit" (_fun _int32 -> _posit8)))
(define int32->posit16 (get-ffi-obj "i32_to_p16" "libsoftposit" (_fun _int32 -> _posit16)))
(define int32->posit32 (get-ffi-obj "i32_to_p32" "libsoftposit" (_fun _int32 -> _posit32)))
(define int64->posit8 (get-ffi-obj "i64_to_p8" "libsoftposit" (_fun _int64 -> _posit8)))
(define int64->posit16 (get-ffi-obj "i64_to_p16" "libsoftposit" (_fun _int64 -> _posit16)))
(define int64->posit32 (get-ffi-obj "i64_to_p32" "libsoftposit" (_fun _int64 -> _posit32)))

;; TODO: isNaRP8UI function

;; NOTE: these functions use uint_fastxx_t in the c code
(define posit8->uint32 (get-ffi-obj "p8_to_ui32" "libsoftposit" (_fun _posit8 -> _uint32)))
(define posit8->uint64 (get-ffi-obj "p8_to_ui64" "libsoftposit" (_fun _posit8 -> _uint64)))
(define posit8->int32 (get-ffi-obj "p8_to_i32" "libsoftposit" (_fun _posit8 -> _int32)))
(define posit8->int64 (get-ffi-obj "p8_to_i64" "libsoftposit" (_fun _posit8 -> _int64)))

(define posit8->posit16 (get-ffi-obj "p8_to_p16" "libsoftposit" (_fun _posit8 -> _posit16)))
(define posit8->posit32 (get-ffi-obj "p8_to_p32" "libsoftposit" (_fun _posit8 -> _posit32)))

(define posit8-round-to-int (get-ffi-obj "p8_roundToInt" "libsoftposit" (_fun _posit8 -> _posit8)))
(define posit8-add (get-ffi-obj "p8_add" "libsoftposit" (_fun _posit8 _posit8 -> _posit8)))
(define posit8-sub (get-ffi-obj "p8_sub" "libsoftposit" (_fun _posit8 _posit8 -> _posit8)))
(define posit8-mul (get-ffi-obj "p8_mul" "libsoftposit" (_fun _posit8 _posit8 -> _posit8)))
(define posit8-mulAdd (get-ffi-obj "p8_mulAdd" "libsoftposit" (_fun _posit8 _posit8 _posit8 -> _posit8)))
(define posit8-div (get-ffi-obj "p8_div" "libsoftposit" (_fun _posit8 _posit8 -> _posit8)))
(define posit8-sqrt (get-ffi-obj "p8_sqrt" "libsoftposit" (_fun _posit8 -> _posit8)))
(define (posit8-neg p) (posit8-sub (double->posit8 0.0) p))

(define (posit8= x y . rest)
  (define fn (get-ffi-obj "p8_eq" "libsoftposit" (_fun _posit8 _posit8 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit8<= x y . rest)
  (define fn (get-ffi-obj "p8_le" "libsoftposit" (_fun _posit8 _posit8 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit8< x y  . rest)
  (define fn (get-ffi-obj "p8_lt" "libsoftposit" (_fun _posit8 _posit8 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit8>= x y . rest)
  (define (fn x y) (posit8<= y x))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit8> x y . rest)
  (define (fn x y) (posit8< y x))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))

;; NOTE: make-quirexx is auto-generated by the define-cstruct so we call them create-quirexx
(define (create-quire8 [v null])
  (if (eq? v null)
    (make-quire8 0)
    (quire8-fdp-add (create-quire8) v (double->posit8 1.0))))
(define (create-quire16 [v null])
  (if (eq? v null)
    (make-quire16 (list->cblock '(0 0) _uint64))
    (quire16-fdp-add (create-quire16) v (double->posit16 1.0))))
(define (create-quire32 [v null])
  (if (eq? v null)
    (make-quire32 (list->cblock '(0 0 0 0 0 0 0 0) _uint64))
    (quire32-fdp-add (create-quire32) v (double->posit32 1.0))))

(define quire8-fdp-add (get-ffi-obj "q8_fdp_add" "libsoftposit" (_fun _quire8 _posit8 _posit8 -> _quire8)))
(define quire8-fdp-sub (get-ffi-obj "q8_fdp_sub" "libsoftposit" (_fun _quire8 _posit8 _posit8 -> _quire8)))
(define quire8->posit8 (get-ffi-obj "q8_to_p8" "libsoftposit" (_fun _quire8 -> _posit8)))

;; TODO: isNaRQ8, isQ8Zero, (consider q8Clr), castQ8, castP8, negP8

(define posit8->double (get-ffi-obj "convertP8ToDouble" "libsoftposit" (_fun _posit8 -> _double)))
(define (double->posit8 x)
  (define fn (get-ffi-obj "convertDoubleToP8" "libsoftposit" (_fun _double -> _posit8)))
  (if (exact? x)
    (fn (exact->inexact x))
    (fn x)))

(define posit16->uint32 (get-ffi-obj "p16_to_ui32" "libsoftposit" (_fun _posit16 -> _uint32)))
(define posit16->uint64 (get-ffi-obj "p16_to_ui64" "libsoftposit" (_fun _posit16 -> _uint64)))
(define posit16->int32 (get-ffi-obj "p16_to_i32" "libsoftposit" (_fun _posit16 -> _int32)))
(define posit16->int64 (get-ffi-obj "p16_to_i64" "libsoftposit" (_fun _posit16 -> _int64)))

(define posit16->posit8 (get-ffi-obj "p16_to_p8" "libsoftposit" (_fun _posit16 -> _posit8)))
(define posit16->posit32 (get-ffi-obj "p16_to_p32" "libsoftposit" (_fun _posit16 -> _posit32)))

(define posit16-round-to-int (get-ffi-obj "p16_roundToInt" "libsoftposit" (_fun _posit16 -> _posit16)))
(define posit16-add (get-ffi-obj "p16_add" "libsoftposit" (_fun _posit16 _posit16 -> _posit16)))
(define posit16-sub (get-ffi-obj "p16_sub" "libsoftposit" (_fun _posit16 _posit16 -> _posit16)))
(define posit16-mul (get-ffi-obj "p16_mul" "libsoftposit" (_fun _posit16 _posit16 -> _posit16)))
(define posit16-mulAdd (get-ffi-obj "p16_mulAdd" "libsoftposit" (_fun _posit16 _posit16 _posit16 -> _posit16)))
(define posit16-div (get-ffi-obj "p16_div" "libsoftposit" (_fun _posit16 _posit16 -> _posit16)))
(define posit16-sqrt (get-ffi-obj "p16_sqrt" "libsoftposit" (_fun _posit16 -> _posit16)))
(define (posit16-neg p) (posit16-sub (double->posit16 0.0) p))

(define (posit16= x y . rest)
  (define fn (get-ffi-obj "p16_eq" "libsoftposit" (_fun _posit16 _posit16 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit16<= x y . rest)
  (define fn (get-ffi-obj "p16_le" "libsoftposit" (_fun _posit16 _posit16 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit16< x y  . rest)
  (define fn (get-ffi-obj "p16_lt" "libsoftposit" (_fun _posit16 _posit16 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit16>= x y . rest)
  (define (fn x y) (posit16<= y x))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit16> x y . rest)
  (define (fn x y) (posit16< y x))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))

(define quire16-fdp-add (get-ffi-obj "q16_fdp_add" "libsoftposit" (_fun _quire16 _posit16 _posit16 -> _quire16)))
(define quire16-fdp-sub (get-ffi-obj "q16_fdp_sub" "libsoftposit" (_fun _quire16 _posit16 _posit16 -> _quire16)))
(define quire16->posit16 (get-ffi-obj "q16_to_p16" "libsoftposit" (_fun _quire16 -> _posit16)))

(define quire16-twos-complement (get-ffi-obj "q16_TwosComplement" "libsoftposit" (_fun _quire16 -> _quire16)))

(define posit16->double (get-ffi-obj "convertP16ToDouble" "libsoftposit" (_fun _posit16 -> _double)))
(define float->posit16 (get-ffi-obj "convertFloatToP16" "libsoftposit" (_fun _float -> _posit16)))
(define (double->posit16 x)
  (define fn (get-ffi-obj "convertDoubleToP16" "libsoftposit" (_fun _double -> _posit16)))
  (if (exact? x)
    (fn (exact->inexact x))
    (fn x)))

(define posit32->uint32 (get-ffi-obj "p32_to_ui32" "libsoftposit" (_fun _posit32 -> _uint32)))
(define posit32->uint64 (get-ffi-obj "p32_to_ui64" "libsoftposit" (_fun _posit32 -> _uint64)))
(define posit32->int32 (get-ffi-obj "p32_to_i32" "libsoftposit" (_fun _posit32 -> _int32)))
(define posit32->int64 (get-ffi-obj "p32_to_i64" "libsoftposit" (_fun _posit32 -> _int64)))

(define posit32->posit8 (get-ffi-obj "p32_to_p8" "libsoftposit" (_fun _posit32 -> _posit8)))
(define posit32->posit16 (get-ffi-obj "p32_to_p16" "libsoftposit" (_fun _posit32 -> _posit16)))

(define posit32-round-to-int (get-ffi-obj "p32_roundToInt" "libsoftposit" (_fun _posit32 -> _posit32)))
(define posit32-add (get-ffi-obj "p32_add" "libsoftposit" (_fun _posit32 _posit32 -> _posit32)))
(define posit32-sub (get-ffi-obj "p32_sub" "libsoftposit" (_fun _posit32 _posit32 -> _posit32)))
(define posit32-mul (get-ffi-obj "p32_mul" "libsoftposit" (_fun _posit32 _posit32 -> _posit32)))
(define posit32-mulAdd (get-ffi-obj "p32_mulAdd" "libsoftposit" (_fun _posit32 _posit32 _posit32 -> _posit32)))
(define posit32-div (get-ffi-obj "p32_div" "libsoftposit" (_fun _posit32 _posit32 -> _posit32)))
(define posit32-sqrt (get-ffi-obj "p32_sqrt" "libsoftposit" (_fun _posit32 -> _posit32)))
(define (posit32-neg p) (posit32-sub (double->posit32 0.0) p))

(define (posit32= x y . rest)
  (define fn (get-ffi-obj "p32_eq" "libsoftposit" (_fun _posit32 _posit32 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit32<= x y . rest)
  (define fn (get-ffi-obj "p32_le" "libsoftposit" (_fun _posit32 _posit32 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit32< x y  . rest)
  (define fn (get-ffi-obj "p32_lt" "libsoftposit" (_fun _posit32 _posit32 -> _bool)))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit32>= x y . rest)
  (define (fn x y) (posit32<= y x))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))
(define (posit32> x y . rest)
  (define (fn x y) (posit32< y x))
  (define args `(,x ,y ,@rest))
  (for/and ([a args] [b (cdr args)])
    (fn a b)))

(define quire32-fdp-add (get-ffi-obj "q32_fdp_add" "libsoftposit" (_fun _quire32 _posit32 _posit32 -> _quire16)))
(define quire32-fdp-sub (get-ffi-obj "q32_fdp_sub" "libsoftposit" (_fun _quire32 _posit32 _posit32 -> _quire16)))
(define quire32->posit32 (get-ffi-obj "q32_to_p32" "libsoftposit" (_fun _quire32 -> _posit32)))

(define quire32-twos-complement (get-ffi-obj "q32_TwosComplement" "libsoftposit" (_fun _quire32 -> _quire32)))

(define posit32->double (get-ffi-obj "convertP32ToDouble" "libsoftposit" (_fun _posit32 -> _double)))
(define float->posit32 (get-ffi-obj "convertFloatToP32" "libsoftposit" (_fun _float -> _posit32)))
(define (double->posit32 x)
  (define fn (get-ffi-obj "convertDoubleToP32" "libsoftposit" (_fun _double -> _posit32)))
  (if (exact? x)
    (fn (exact->inexact x))
    (fn x)))

(define (posit8->quire8 p) (create-quire8 p))
(define (posit16->quire16 p) (create-quire16 p))
(define (posit32->quire32 p) (create-quire32 p))

(define (double->quire8 d) (create-quire8 (double->posit8 d)))
(define (double->quire16 d) (create-quire16 (double->posit16 d)))
(define (double->quire32 d) (create-quire32 (double->posit32 d)))

(define (quire8->double q) (posit8->double (quire8->posit8 q)))
(define (quire16->double q) (posit16->double (quire16->posit16 q)))
(define (quire32->double q) (posit32->double (quire32->posit32 q)))

(define posit8->ordinal (get-ffi-obj "p8_ordinal" "libsoftposit" (_fun _posit8 -> _int8)))
(define posit16->ordinal (get-ffi-obj "p16_ordinal" "libsoftposit" (_fun _posit16 -> _int16)))
(define posit32->ordinal (get-ffi-obj "p32_ordinal" "libsoftposit" (_fun _posit32 -> _int32)))

(define ordinal->posit8 (get-ffi-obj "ordinal_p8" "libsoftposit" (_fun _int64 -> _posit8)))
(define ordinal->posit16 (get-ffi-obj "ordinal_p16" "libsoftposit" (_fun _int64 -> _posit16)))
(define ordinal->posit32 (get-ffi-obj "ordinal_p32" "libsoftposit" (_fun _int64 -> _posit32)))


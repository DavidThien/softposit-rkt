#lang scribble/manual
@require[@for-label[softposit-rkt
                    racket/base]]

@title{softposit-rkt}
@author{David Thien}

@section{Introduction}
This package is a set of racket bindings for the @hyperlink["https://gitlab.com/cerlane/SoftPosit"]{SoftPosit} library. More information on posits can be found on @hyperlink["https://posithub.org/"]{Posithub}. Posits are an alternative to floating point numbers designed to improve performance and accuracy.

@section{API}

@defmodule[softposit-rkt]

@subsection{Posits}

Posits themselves are a representation of the @hyperlink["https://en.wikipedia.org/wiki/Real_projective_line"]{projective reals}. The different sizes of posits are included this package are @racket[_posit8] @racket[_posit16] @racket[_posit32] @racket[_posit64] and @racket[_posit128]. Note thought that only the 8, 16, and 32 bit posits currently have arithmetic operators implemented.

The posit types in this package are bindings for c types. Note that only the types and type predicates are bound. All other operations with posits should be accessed with the other provided functions.

@subsection{Posit Types}

@defthing[_posit8 ctype?]{
  An 8-bit posit.
}

@defthing[_posit16 ctype?]{
  A 16-bit posit.
}

@defthing[_posit32 ctype?]{
  A 32-bit posit.
}

@defthing[_posit64 ctype?]{
  A 64-bit posit.
}

@defthing[_posit128 ctype?]{
  A 128-bit posit.
}

@defproc[(posit8? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_posit8], @racket[#f] otherwise.
}

@defproc[(posit16? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_posit16], @racket[#f] otherwise.
}

@defproc[(posit32? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_posit32], @racket[#f] otherwise.
}

@defproc[(posit64? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_posit64], @racket[#f] otherwise.
}

@defproc[(posit128? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_posit128], @racket[#f] otherwise.
}

@subsection{Creating Posits}

@defproc[(uint32->posit8 [n natural?]) posit8?]{
  Creates a new @racket[_posit8] that is the closest representable value to @racket[n].
}

@defproc[(uint32->posit16 [n natural?]) posit16?]{
  Creates a new @racket[_posit16] that is the closest representable value to @racket[n].
}

@defproc[(uint32->posit32 [n natural?]) posit32?]{
  Creates a new @racket[_posit32] that is the closest representable value to @racket[n].
}

@defproc[(uint64->posit8 [n natural?]) posit8?]{
  Creates a new @racket[_posit8] that is the closest representable value to @racket[n].
}

@defproc[(uint64->posit16 [n natural?]) posit16?]{
  Creates a new @racket[_posit16] that is the closest representable value to @racket[n].
}

@defproc[(uint64->posit32 [n natural?]) posit32?]{
  Creates a new @racket[_posit32] that is the closest representable value to @racket[n].
}

@defproc[(int32->posit8 [n integer?]) posit8?]{
  Creates a new @racket[_posit8] that is the closest representable value to @racket[n].
}

@defproc[(int32->posit16 [n integer?]) posit16?]{
  Creates a new @racket[_posit16] that is the closest representable value to @racket[n].
}

@defproc[(int32->posit32 [n integer?]) posit32?]{
  Creates a new @racket[_posit32] that is the closest representable value to @racket[n].
}

@defproc[(int64->posit8 [n integer?]) posit8?]{
  Creates a new @racket[_posit8] that is the closest representable value to @racket[n].
}

@defproc[(int64->posit16 [n integer?]) posit16?]{
  Creates a new @racket[_posit16] that is the closest representable value to @racket[n].
}

@defproc[(int64->posit32 [n integer?]) posit32?]{
  Creates a new @racket[_posit32] that is the closest representable value to @racket[n].
}

@defproc[(double->posit8 [n real?]) posit8?]{
  Creates a new @racket[_posit8] that is the closest representable value to @racket[n].
}

@defproc[(double->posit16 [n real?]) posit16?]{
  Creates a new @racket[_posit16] that is the closest representable value to @racket[n].
}

@defproc[(double->posit32 [n real?]) posit32?]{
  Creates a new @racket[_posit32] that is the closest representable value to @racket[n].
}

@subsection{Converting Between Posit Types}

@defproc[(posit8->posit16 [p posit8?]) posit16?]{
  Converts a @racket[_posit8] to a @racket[_posit16].
}

@defproc[(posit8->posit32 [p posit8?]) posit32?]{
  Converts a @racket[_posit8] to a @racket[_posit32].
}

@defproc[(posit16->posit8 [p posit16?]) posit8?]{
  Converts a @racket[_posit16] to a @racket[_posit8].
}

@defproc[(posit16->posit32 [p posit16?]) posit32?]{
  Converts a @racket[_posit16] to a @racket[_posit32].
}

@defproc[(posit32->posit8 [p posit32?]) posit8?]{
  Converts a @racket[_posit32] to a @racket[_posit8].
}

@defproc[(posit32->posit16 [p posit32?]) posit16?]{
  Converts a @racket[_posit32] to a @racket[_posit16].
}

@subsection{Converting Back from Posits}

Note that there are multiple bindings exposed which cast back to natural numbers and to integers (e.g. @racket[posit16->uint32] and @racket[posit16->uint64]). Although these will cast back to the same racket type, they are different functions in the underlying C code, so be careful to avoid unexpected behavior when hitting the maximum value for uint32s. It is recommended to always cast to a double to avoid losing decimal accuracy.

@defproc[(posit8->uint32 [p posit8?]) natural?]{
  Casts a @racket[_posit8] to a uint32.
}

@defproc[(posit16->uint32 [p posit16?]) natural?]{
  Casts a @racket[_posit16] to a uint32.
}

@defproc[(posit32->uint32 [p posit32?]) natural?]{
  Casts a @racket[_posit32] to a uint32.
}

@defproc[(posit8->uint64 [p posit8?]) natural?]{
  Casts a @racket[_posit8] to a uint64.
}

@defproc[(posit16->uint64 [p posit16?]) natural?]{
  Casts a @racket[_posit16] to a uint64.
}

@defproc[(posit32->uint64 [p posit32?]) natural?]{
  Casts a @racket[_posit32] to a uint64.
}

@defproc[(posit8->int32 [p posit8?]) integer?]{
  Casts a @racket[_posit8] to a int32.
}

@defproc[(posit16->int32 [p posit16?]) integer?]{
  Casts a @racket[_posit16] to a int32.
}

@defproc[(posit32->int32 [p posit32?]) integer?]{
  Casts a @racket[_posit32] to a int32.
}

@defproc[(posit8->int64 [p posit8?]) integer?]{
  Casts a @racket[_posit8] to a int64.
}

@defproc[(posit16->int64 [p posit16?]) integer?]{
  Casts a @racket[_posit16] to a int64.
}

@defproc[(posit32->int64 [p posit32?]) integer?]{
  Casts a @racket[_posit32] to a int64.
}

@defproc[(posit8->double [p posit8?]) real?]{
  Casts a @racket[_posit8] to a double.
}

@defproc[(posit16->double [p posit16?]) real?]{
  Casts a @racket[_posit16] to a int64.
}

@defproc[(posit32->double [p posit32?]) real?]{
  Casts a @racket[_posit32] to a int64.
}

@subsection{Posit Operations}

@defproc[(posit8-round-to-int [p posit8?]) posit8?]{
  Rounds @racket[p] to the nearest integer.
}

@defproc[(posit8-add [p1 posit8?] [p2 posit8?]) posit8?]{
  Adds @racket[p1] and @racket[p2].
}

@defproc[(posit8-sub [p1 posit8?] [p2 posit8?]) posit8?]{
  Subtracts @racket[p2] from @racket[p1].
}

@defproc[(posit8-mul [p1 posit8?] [p2 posit8?]) posit8?]{
  Multiplies @racket[p1] and @racket[p2].
}

@defproc[(posit8-div [p1 posit8?] [p2 posit8?]) posit8?]{
  Divides @racket[p1] by @racket[p2].
}

@defproc[(posit8mulAdd [p1 posit8?] [p2 posit8?] [p3 posit8?]) posit8?]{
  Performs the operation @racket[(p1 * p2) + p3] (similar to the @racket[fma] operator).
}

@defproc[(posit8-sqrt [p1 posit8?]) posit8?]{
  Takes the square root of @racket[p1].
}

@defproc[(posit8-neg [p1 posit8?]) posit8?]{
  Negates @racket[p1].
}

@defproc[(posit16-neg [p1 posit16?]) posit16?]{
  Negates @racket[p1].
}

@defproc[(posit32-neg [p1 posit32?]) posit32?]{
  Negates @racket[p1].
}

@defproc[(posit8= [p1 posit8?] [p2 posit8?]) boolean?]{
  Returns @racket[#t] if @racket[p1] and @racket[p2] are equal.
}

@defproc[(posit8< [p1 posit8?] [p2 posit8?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is strictly less than @racket[p2].
}

@defproc[(posit8<= [p1 posit8?] [p2 posit8?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is less than or equal to @racket[p2].
}

@defproc[(posit8> [p1 posit8?] [p2 posit8?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is greater than to @racket[p2].
}

@defproc[(posit8>= [p1 posit8?] [p2 posit8?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is greater than or equal to @racket[p2].
}

@defproc[(posit16-round-to-int [p posit16?]) posit16?]{
  Rounds @racket[p] to the nearest integer.
}

@defproc[(posit16-add [p1 posit16?] [p2 posit16?]) posit16?]{
  Adds @racket[p1] and @racket[p2].
}

@defproc[(posit16-sub [p1 posit16?] [p2 posit16?]) posit16?]{
  Subtracts @racket[p2] from @racket[p1].
}

@defproc[(posit16-mul [p1 posit16?] [p2 posit16?]) posit16?]{
  Multiplies @racket[p1] and @racket[p2].
}

@defproc[(posit16-div [p1 posit16?] [p2 posit16?]) posit16?]{
  Divides @racket[p1] by @racket[p2].
}

@defproc[(posit16mulAdd [p1 posit16?] [p2 posit16?] [p3 posit16?]) posit16?]{
  Performs the operation @racket[(p1 * p2) + p3] (similar to the @racket[fma] operator).
}

@defproc[(posit16-sqrt [p1 posit16?]) posit16?]{
  Takes the square root of @racket[p1].
}

@defproc[(posit16= [p1 posit16?] [p2 posit16?]) boolean?]{
  Returns @racket[#t] if @racket[p1] and @racket[p2] are equal.
}

@defproc[(posit16< [p1 posit16?] [p2 posit16?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is strictly less than @racket[p2].
}

@defproc[(posit16<= [p1 posit16?] [p2 posit16?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is less than or equal to @racket[p2].
}

@defproc[(posit16> [p1 posit16?] [p2 posit16?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is greater than to @racket[p2].
}

@defproc[(posit16>= [p1 posit16?] [p2 posit16?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is greater than or equal to @racket[p2].
}

@defproc[(posit32-round-to-int [p posit32?]) posit32?]{
  Rounds @racket[p] to the nearest integer.
}

@defproc[(posit32-add [p1 posit32?] [p2 posit32?]) posit32?]{
  Adds @racket[p1] and @racket[p2].
}

@defproc[(posit32-sub [p1 posit32?] [p2 posit32?]) posit32?]{
  Subtracts @racket[p2] from @racket[p1].
}

@defproc[(posit32-mul [p1 posit32?] [p2 posit32?]) posit32?]{
  Multiplies @racket[p1] and @racket[p2].
}

@defproc[(posit32-div [p1 posit32?] [p2 posit32?]) posit32?]{
  Divides @racket[p1] by @racket[p2].
}

@defproc[(posit32mulAdd [p1 posit32?] [p2 posit32?] [p3 posit32?]) posit32?]{
  Performs the operation @racket[(p1 * p2) + p3] (similar to the @racket[fma] operator).
}

@defproc[(posit32-sqrt [p1 posit32?]) posit32?]{
  Takes the square root of @racket[p1].
}

@defproc[(posit32= [p1 posit32?] [p2 posit32?]) boolean?]{
  Returns @racket[#t] if @racket[p1] and @racket[p2] are equal.
}

@defproc[(posit32< [p1 posit32?] [p2 posit32?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is strictly less than @racket[p2].
}

@defproc[(posit32<= [p1 posit32?] [p2 posit32?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is less than or equal to @racket[p2].
}

@defproc[(posit32> [p1 posit32?] [p2 posit32?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is greater than to @racket[p2].
}

@defproc[(posit32>= [p1 posit32?] [p2 posit32?]) boolean?]{
  Returns @racket[#t] if @racket[p1] is greater than or equal to @racket[p2].
}

@subsection{Quires}

Quires are another feature of the Posit specication. They can be thought of as a large accumulator designed to hold enough bits of information so as to not introduce any rounding error. Note that these accumulators have a fixed number of bits, so only a limited (but very large) number of accumulations can be done on them safely. A @racket[_quire8] has 4 times the number of bits as a @racket[_posit8], a @racket[_quire16] has 8 times the bits as a @racket[_posit16], and a @racket[_quire32] has 16 times the bits as a @racket[_posit32].

@subsection{Quire Types}

@defthing[_quire8 ctype?]{
  An 8-bit quire.
}

@defthing[_quire16 ctype?]{
  An 16-bit quire.
}

@defthing[_quire32 ctype?]{
  An 32-bit quire.
}

@defproc[(quire8? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_quire8], @racket[#f] otherwise.
}

@defproc[(quire16? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_quire16], @racket[#f] otherwise.
}

@defproc[(quire32? [v any/c]) boolean?]{
  Returns @racket[#t] if v is a @racket[_quire32], @racket[#f] otherwise.
}

@subsection{Creating Quires}

All quires are initialized to 0.

@defproc[(create-quire8) quire8?]{
  Creates a new @racket[_quire8].
}

@defproc[(create-quire16) quire16?]{
  Creates a new @racket[_quire16].
}

@defproc[(create-quire32) quire32?]{
  Creates a new @racket[_quire32].
}

@defproc[(posit8->quire8 [p posit8?]) quire8?]{
  Creates a quire8 with the value of @racket[q].
}

@defproc[(posit16->quire16 [p posit16?]) quire16?]{
  Creates a quire16 with the value of @racket[q].
}

@defproc[(posit32->quire32 [p posit32?]) quire32?]{
  Creates a quire32 with the value of @racket[q].
}

@defproc[(double>quire8 [n real?]) quire8?]{
  Creates a quire8 with the value of @racket[n] after @racket[n] is converted to a @racket[posit8].
}

@defproc[(double>quire16 [n real?]) quire16?]{
  Creates a quire16 with the value of @racket[n] after @racket[n] is converted to a @racket[posit16].
}

@defproc[(double>quire32 [n real?]) quire32?]{
  Creates a quire32 with the value of @racket[n] after @racket[n] is converted to a @racket[posit32].
}

@subsection{Quire Operations}

Note that there is currently no twos-complement for @racket[_quire8]s.

@defproc[(quire8-fdp-add [q quire8?] [p1 posit8?] [p2 posit8?]) quire8?]{
  Returns the result of adding @racket[p1] times @racket[p2] to @racket[q].
}

@defproc[(quire8-fdp-sub [q quire8?] [p1 posit8?] [p2 posit8?]) quire8?]{
  Returns the result of subtracting @racket[p1] times @racket[p2] from @racket[q].
}

@defproc[(quire16-fdp-add [q quire16?] [p1 posit16?] [p2 posit16?]) quire16?]{
  Returns the result of adding @racket[p1] times @racket[p2] to @racket[q].
}

@defproc[(quire16-fdp-sub [q quire16?] [p1 posit16?] [p2 posit16?]) quire16?]{
  Returns the result of subtracting @racket[p1] times @racket[p2] from @racket[q].
}

@defproc[(quire16-twos-complement [q quire16?]) quire16?]{
  Returns the twos complement of @racket[q].
}

@defproc[(quire32-fdp-add [q quire32?] [p1 posit32?] [p2 posit32?]) quire32?]{
  Returns the result of adding @racket[p1] times @racket[p2] to @racket[q].
}

@defproc[(quire32-fdp-sub [q quire32?] [p1 posit32?] [p2 posit32?]) quire32?]{
  Returns the result of subtracting @racket[p1] times @racket[p2] from @racket[q].
}

@defproc[(quire32-twos-complement [q quire32?]) quire32?]{
  Returns the twos complement of @racket[q].
}

@subsection{Retrieving Values from Quires}

@defproc[(quire8->posit8 [q quire8?]) posit8?]{
  Casts @racket[q] to a @racket[_posit8].
}

@defproc[(quire16->posit16 [q quire16?]) posit16?]{
  Casts @racket[q] to a @racket[_posit16].
}

@defproc[(quire32->posit32 [q quire32?]) posit32?]{
  Casts @racket[q] to a @racket[_posit32].
}

@defproc[(quire8->double [q quire8?]) real?]{
  Casts @racket[q] to a double.
}

@defproc[(quire16->double [q quire16?]) real?]{
  Casts @racket[q] to a double.
}

@defproc[(quire32->double [q quire32?]) real?]{
  Casts @racket[q] to a double.
}

@subsection{Generating Random Posits and Quires}

Also included is functionality to generate random posits and quires.

@defproc[(random-posit8) posit8?]{
  Generates a random posit8.
}

@defproc[(random-posit16) posit16?]{
  Generates a random posit16.
}

@defproc[(random-posit32) posit32?]{
  Generates a random posit32.
}

@defproc[(random-posit64) posit64?]{
  Generates a random posit64.
}

@defproc[(random-posit128) posit128?]{
  Generates a random posit128.
}

@defproc[(random-quire8) quire8?]{
  Generates a random quire8.
}

@defproc[(random-quire16) quire16?]{
  Generates a random quire16.
}

@defproc[(random-quire32) quire32?]{
  Generates a random quire32.
}

@subsection{Posit Constants}

@defproc[(posit8-inf) posit8?]{
  Returns the +/- infinity value for posit8s.
}

@defproc[(posit16-inf) posit16?]{
  Returns the +/- infinity value for posit16s.
}

@defproc[(posit32-inf) posit32?]{
  Returns the +/- infinity value for posit32s.
}

@defproc[(posit64-inf) posit64?]{
  Returns the +/- infinity value for posit64s.
}

@defproc[(posit128-inf) posit128?]{
  Returns the +/- infinity value for posit128s.
}

@subsection{Posit Ordered Indices}
These functions return the index of a posit in an ordered list of that posit's type. Starts with the infinity value returning 0.

@defproc[(p8-order-index [p posit8?]) natural?]{
  Returns the index of @racket[p] in an ordered list of @racket[posit8]s.
}

@defproc[(p16-order-index [p posit16?]) natural?]{
  Returns the index of @racket[p] in an ordered list of @racket[posit16]s.
}

@defproc[(p32-order-index [p posit32?]) natural?]{
  Returns the index of @racket[p] in an ordered list of @racket[posit32]s.
}

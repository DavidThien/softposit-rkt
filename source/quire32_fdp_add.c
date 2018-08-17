/*============================================================================

This C source file is part of the SoftPosit Posit Arithmetic Package
by S. H. Leong (Cerlane).

Copyright 2017, 2018 A*STAR.  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

#include <inttypes.h>

#include "platform.h"
#include "internals.h"

quire32_t q32_fdp_add( quire32_t q, posit32_t pA, posit32_t pB ){

	union ui32_p32 uA, uB;
	union ui512_q32 uZ, uZ1, uZ2;
	uint_fast32_t uiA, uiB;
	uint_fast32_t regA, fracA, regime, tmp;
	bool signA, signB, signZ2, regSA, regSB, bitNPlusOne=0, bitsMore=0, rcarry;
	int_fast32_t expA, expB;
	int_fast16_t kA=0, shiftRight=0;
	uint_fast64_t frac64Z;
	//For add
	bool rcarryb, b1, b2, rcarryZ, rcarrySignZ;

	uZ1.q = q;

	uA.p = pA;
	uiA = uA.ui;
	uB.p = pB;
	uiB = uB.ui;

	uZ2.q = q32_clr(uZ2.q); //set it to zero
	//NaR
	if (isNaRQ32(q) || isNaRP32UI(uA.ui) || isNaRP32UI(uB.ui)){
		//set to all zeros
		uZ2.ui[0]=0x8000000000000000ULL;
		return uZ2.q;
	}
	else if (uiA==0 || uiB==0)
		return q;


	//max pos (sign plus and minus)
	signA = signP32UI( uiA );
	signB = signP32UI( uiB );
	signZ2 = signA ^ signB;

	if(signA) uiA = (-uiA & 0xFFFFFFFF);
	if(signB) uiB = (-uiB & 0xFFFFFFFF);

	regSA = signregP32UI(uiA);
	regSB = signregP32UI(uiB);

	tmp = (uiA<<2) & 0xFFFFFFFF;
	if (regSA){
		while (tmp>>31){
			kA++;
			tmp= (tmp<<1) & 0xFFFFFFFF;
		}
	}
	else{
		kA=-1;
		while (!(tmp>>31)){
			kA--;
			tmp= (tmp<<1) & 0xFFFFFFFF;
		}
		tmp&=0x7FFFFFFF;
	}
	expA = tmp>>29; //to get 2 bits

	fracA = ((tmp<<2) | 0x80000000) & 0xFFFFFFFF;


	tmp = (uiB<<2) & 0xFFFFFFFF;
	if (regSB){
		while (tmp>>31){
			kA++;
			tmp= (tmp<<1) & 0xFFFFFFFF;
		}
	}
	else{
		kA--;
		while (!(tmp>>31)){
			kA--;
			tmp= (tmp<<1) & 0xFFFFFFFF;
		}
		tmp&=0x7FFFFFFF;
	}
	expA += tmp>>29;

	frac64Z = (uint_fast64_t) fracA * (((tmp<<2) | 0x80000000) & 0xFFFFFFFF);

	if (expA>3){
		kA++;
		expA&=0x3; // -=4
	}
	//Will align frac64Z such that hidden bit is the first bit on the left.
	rcarry = frac64Z>>63;//1st bit of frac64Z
	if (rcarry){
		expA++;
		if (expA>3){
			kA ++;
			expA&=0x3;
		}
	}
	else
		frac64Z<<=1;

	//default dot is between bit 271 and 272, extreme left bit is bit 0. Last right bit is bit 512.
	//Minpos is 120 position to the right of binary point (dot)
	//Scale = 2^es * k + e  => 2k + e
	int firstPos = 271 - (kA<<2) - expA;

	//Moving in chunk of 64. If it is in first chunk, a part might be in the chunk right to it. Simply have to handle that.
	int i;
	for (i=0; i<8; i++){
		if (firstPos<(i+1)*64){
			//Need to check how much of the fraction is in the next 64 bits
			shiftRight = firstPos - (i*64);
			uZ2.ui[i] = frac64Z >> shiftRight;
			if (i!=7) uZ2.ui[i+1] = frac64Z << (64 - shiftRight);
			break;
		}
	}

	if (signZ2){
		for (i=7; i>=0; i--){
			if (uZ2.ui[i]>0){
				uZ2.ui[i] = - uZ2.ui[i];
				i--;
				while(i){
					uZ2.ui[i] = ~uZ2.ui[i];
				}
				break;
			}
		}

	}

	//Addition
	for (i=7; i>=0; i--){
		b1 = uZ1.ui[i] & 0x1;
		b2 = uZ2.ui[i] & 0x1;

		rcarryb = b1 & b2;
		uZ.ui[i] = (uZ1.ui[i]>>1) + (uZ2.ui[i]>>1) + rcarryb;
		int_fast8_t rcarryb3;
		if (i<7){
			rcarryb3 = b1 + b2 + rcarryZ;
			uZ.ui[i] += ((rcarryb3>>1)& 0x1);
			rcarryZ = uZ.ui[i]>>63;
			uZ.ui[i] = (uZ.ui[i]<<1 | (rcarryb3 & 0x1) );
		}
		else{
			rcarryZ = uZ.ui[i]>>63;
			uZ.ui[i] = (uZ.ui[i]<<1 | (b1^b2) );
		}

	}

	//Exception handling
	if (isNaRQ32(uZ.q) ) uZ.q = q32_clr(uZ.q);

	return uZ.q;
}

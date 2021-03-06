global sepia_one

extern convert_to_b4g4r4
extern convert_from_b4g4r4

section .data

cols:

	dd 0.393,0.349,0.272,0.393	;round 1
	dd 0.769,0.686,0.543,0.769
	dd 0.189,0.168,0.131,0.189

	dd 0.349,0.272,0.393,0.349	;round 2
	dd 0.686,0.543,0.769,0.686
	dd 0.168,0.131,0.189,0.168

	dd 0.272,0.393,0.349,0.272	;round 3
	dd 0.543,0.769,0.686,0.543
	dd 0.131,0.189,0.168,0.131
section .text

sepia_one:
	push rbp
	mov rbp,rsp
	sub rsp, 96
	mov rsi, rbp
	sub rsi, 48
	lea rbx, [rel cols]
loop:
	push rdi
	push rsi
	call convert_to_b4g4r4

	CVTDQ2PS xmm0, [rbp-48]
	CVTDQ2PS xmm1, [rbp-32]
	CVTDQ2PS xmm2, [rbp-16]

	MOVAPS xmm3, [rbx]
	MOVAPS xmm4, [rbx+16]
	MOVAPS xmm5, [rbx+32]

	mulps xmm0, xmm3
	mulps xmm1, xmm4
	mulps xmm2, xmm5

	;; FIXME can use ::  DPPS — Dot Product of Packed Single Precision Floating-Point Values
	addps xmm0, xmm1
	addps xmm0, xmm2
	addps xmm0, xmm3
	;; xmm0 = b1|g1|r1|b2
	;; FIXME saturatio

	CVTPS2DQ xmm0, xmm0
	pop rsi
	pop rdi
	xchg rsi, rdi
	movdqa [rdi], xmm0
	call convert_from_b4g4r4
	;; FIXME: ignore 3/4 pixels
	mov rax, 0x16
	leave
	ret


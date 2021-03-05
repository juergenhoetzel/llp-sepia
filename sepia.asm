global sepia_one

extern convert_to_b4g4r4
extern convert_from_b4g4r4

section .data

col1: dd 0.393,0.349,0.272,0.393
col2: dd 0.769,0.686,0.168,0.768
col3: dd 0.189,0.168,0.131,0.189

section .text

sepia_one:
	push rbp
	mov rbp, rsp
	sub rsp, 512		;FIXME How many
	mov rsi, rbp
	sub rsi, 512
	call convert_to_b4g4r4
	CVTDQ2PS xmm0, [rsi]
	CVTDQ2PS xmm1, [rsi-16]
	CVTDQ2PS xmm2, [rsi-32]

	MOVAPS xmm3, [rel col1]
	MOVAPS xmm4, [rel col2]
	MOVAPS xmm5, [rel col3]

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
	movdqa [rsi], xmm0
	xchg rsi, rdi
	call convert_from_b4g4r4
	;; FIXME: ignore 3/4 pixels
	mov rax, 0x4
	mov rsp, rbp
	pop rbp
	ret


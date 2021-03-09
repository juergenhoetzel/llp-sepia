global sepia_one

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

cols_end:
saturation:
	dd 255.0,255.0,255.0,255.0
section .text

	;; convert one pixel (3 bytes) and 1/3 Pixel.
convert_from_b4g4r4:
	mov al, [rdi]	 ;just get lowest byte
	mov [rsi], al
	mov al, [rdi+4]
	mov [rsi+1], al
	mov al, [rdi+8]
	mov [rsi+2], al
	mov al, [rdi+12]
	mov [rsi+3], al
	ret
	;; convert one pixel (3 bytes) and 1/3 Pixel.
convert_to_b4g4r4:
	;; b
	movzx eax, byte [rdi]
	mov [rsi], eax
	mov [rsi+1*4], eax
	mov [rsi+2*4], eax
	movzx eax, byte [rdi+1*3]
	mov [rsi+3*4], eax
	;; g
	movzx eax, byte [rdi+1]
	mov [rsi+4*4], eax
	mov [rsi+5*4], eax
	mov [rsi+6*4], eax
	movzx eax, byte [rdi+1+1*3]
	mov [rsi+7*4], eax
	;; r
	movzx eax, byte [rdi+2]
	mov [rsi+8*4], eax
	mov [rsi+9*4], eax
	mov [rsi+10*4], eax
	movzx eax, byte[rdi+2+1*3]
	mov [rsi+11*4], eax
	ret

sepia_one:
	push rbp
	mov rbp,rsp
	sub rsp, 96
	mov rsi, rbp
	sub rsi, 48
	lea rbx, [rel cols]
	lea rcx, [rel cols_end]
	MOVAPS xmm7, [rel saturation]
	MOVAPS xmm1, [rbx]
	MOVAPS xmm2, [rbx+16]
	MOVAPS xmm3, [rbx+32]
loop:
	call convert_to_b4g4r4

	CVTDQ2PS xmm4, [rbp-48]
	CVTDQ2PS xmm5, [rbp-32]
	CVTDQ2PS xmm6, [rbp-16]

	mulps xmm4, xmm1
	mulps xmm5, xmm2
	mulps xmm6, xmm3

	addps xmm4, xmm5
	addps xmm4, xmm6
	;; xmm0 = b1|g1|r1|b2
	;; FIXME saturatio
	minps xmm4, xmm7
	CVTPS2DQ xmm4, xmm4
	xchg rsi, rdi
	movdqa [rdi], xmm4
	call convert_from_b4g4r4
	xchg rsi, rdi
	;; next source
	add rdi, 4
	;; next sepia cols

	PSHUFD xmm1, xmm1, 092h
	PSHUFD xmm2, xmm2, 092h
	PSHUFD xmm3, xmm3, 092h
	add rbx, 16*3
	cmp rbx, rcx
	jne loop

	mov rax, 0x4
	leave
	ret


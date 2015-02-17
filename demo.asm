; The MIT License (MIT)

; Copyright (c) 2015 Itay Grudev <itay@grudev.com>

; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.
;
.model small
.code
.386
.stack 128

include libgx.asm

org 100h

x  dw ?
y  dw ?
xd dw ?
yd dw ?
cd db ?
ccd db ?

start:
	gx_set_video_mode_gx

	; Initialize program
	mov x, 270	; CENTER AT 150
	mov y, 30	; CENTER AR 90
	mov xd, 1 ; Initial X direction is negative
	mov yd, 0 ; Initial Y direction is positive
	mov gx_color, 32

mainloop:
	; Check if ESCAPE key is pressed
	call check_keypress
	jz draw 	; No keypress available
	cmp al, 27 	; Check if ASCII code of key is 27 (ESC)
	je exit		; If so exit the program

draw:
	; Clear the previous Square (Totally different effect without it :D)
	;mov dh, gx_color ; Tempoary storing the original color
	;push dx
	;mov gx_color, 16
	;call gx_rect
	;pop dx
	;mov gx_color, dh ; Restoring the original color

	movv gx_x1, x
	movv gx_y1, y
	movv gx_x2, gx_x1
	movv gx_y2, gx_y1
	add gx_x2, 20
	add gx_y2, 20
	call gx_rect

	; Sleep for 2048 microseconds
	mov     cx, 00000h
	mov     dx, 02800h
	mov     ah, 86H
	int     15H

	; Change color every N frames
	cmp ccd, 10
	jl ccdo
	mov ccd, 0
	cmp cd, 1
	je cdec
	inc gx_color
	jmp celse
cdec:
	dec gx_color
celse:
	jmp ccdelse
ccdo:
	inc ccd
ccdelse:

	; Itterate Color
	cmp gx_color, 47
	jge	setcdec
	jmp setcdecelse
setcdec:
	mov gx_color, 32
setcdecelse:

	; Change X Direction
	cmp x, 300
	jge	setxdec
	jmp setxdecelse
setxdec:
	mov xd, 1
setxdecelse:

	cmp x, 0
	jle setxinc
	jmp setxincelse
setxinc:
	mov xd, 0
setxincelse:

	; Change Y Direction
	cmp y, 180
	jge	setydec
	jmp setydecelse
setydec:
	mov yd, 1
setydecelse:

	cmp y, 0
	jle setyinc
	jmp setyincelse
setyinc:
	mov yd, 0
setyincelse:

	; Increment or Decrement X based on X Direction
	cmp xd, 1
	je xdec
	inc x
	jmp xelse
xdec:
	dec x
xelse:

	; Increment or Decrement Y based on Y Direction
	cmp yd, 1
	je ydec
	inc y
	jmp yelse
ydec:
	dec y
yelse:

	jmp mainloop

exit:
	gx_set_video_mode_txt
	return 0

end start

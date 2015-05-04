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

; Move data from a variable into another variable
movv macro to, from
  push from
  pop to
endm

; Compare two memory variables
cmpv macro var1, var2, register
  mov register, var1
  cmp register, var2
endm

; Add two memory variables
addv macro to, from, register
  mov register, to
  add register, from
  mov to, register
endm

; Subtract two memory variables
subv macro to, from, register
  mov register, to
  sub register, from
  mov to, register
endm

; Return Control to DOS
return macro code
  mov ah, 4ch
  mov al, code
  int 21h
endm

; Save registers to stack
save_registers macro
  push ax
  push bx
  push cx
  push dx
endm

; Restore registers from stack
restore_registers macro
  pop dx
  pop cx
  pop bx
  pop ax
endm

; Checks for a keypress; Sets ZF if no keypress is available
; Otherwise returns it's scan code into AH and it's ASCII into al
; Removes the charecter from the Type Ahead Buffer { USING AX }
check_keypress:
  mov ah, 1     ; Checks if there is a character in the type ahead buffer
  int 16h       ; MS-DOS BIOS Keyboard Services Interrupt
  jz check_keypress_empty
  mov ah, 0
  int 16h
  ret
check_keypress_empty:
  cmp ax, ax    ; Explicitly sets the ZF
  ret

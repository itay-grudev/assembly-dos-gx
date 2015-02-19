Assembly DOS GX
===============

This library + the demo I created can help students studying Computer Architecture in their Coursework. You can use it jusr for reference or use all of the Graphics macros and functions I created for you.

It was created for ```TASM```.

Demo
----
This is a simple demo, demonstrating the Usage of the Graphics and the Utilities Libraries.
To compile and run it:
```
> tasm demo.asm
> tlink demo.obj
> demo.exe
```

TODO
----
* Adding line drawing function using Bresenham's line algorithm
* Adding circle drawing function using Bresenham's circle algorithm
* Border only / Filled shapes

Graphics Library
----------------

The graphics library has some neat macros and functions.

### Macros

#### gx_set_video_mode mode
Sets the video mode to whatever mode specified.  

_**Note:** This macro uses the ```AX``` register._

_Usage Example:_
```
gx_set_video_mode 13h
```

---

#### gx_set_video_mode_gx
Sets the video mode ```13h``` - 320x200 256 color graphics (MCGA,VGA).

_**Note:** This macro uses the ```AX``` and ```ES``` registers._

_Usage Example:_
```
gx_set_video_mode_gx
```

---

#### gx_set_video_mode_txt 
Sets the video mode ```03h``` - 80x25 Monochrome text (MDA,HERC,EGA,VGA).

_**Note:** This macro uses the ```AX``` register._

_Usage Example:_
```
gx_set_video_mode_txt
```

---

#### gx_pixel x, y, color
Sets a pixel using Video Memory. Relies upon having the Video Memory star address set in the ```ES``` register. Note that you don't have to do that if you initialised the Graphics mode using: ```gx_set_video_mode_gx``` and you haven't changed the value in the ```ES``` register.

_**Note:** This macro only works if you are using Graphics Mode ```13h``` and you've initialised the graphics mode with the: ```gx_set_video_mode_gx``` macro.

_**Note:** This macro uses the ```AX```, ```BX``` and ```DI``` registers and Video Memory._

_Usage Example:_
```
gx_pixel 10, 10, 47 ; X: 10, Y: 10, Color: 47 (Green)
```

---

#### gx_pixel_bios x, y, color
Sets a pixel using the BIOS ```int 10h``` API.  
This function is slower than ```gx_pixel``` so except in the cases where you must use a Graphics Mode different than ```13h``` the usage if ```gx_pixel``` is recommended.

_**Note:** This macro uses the ```AX```, ```CX``` and ```DX``` registers._

_Usage Example:_
```
gx_pixel_bios 10, 10, 47 ; X: 10, Y: 10, Color: 47 (Green)
```

### Functions

#### gx_rect
Draws a filled rectange between (x1;y1) and (x2;y2)
Parameters:
* ```gx_x1```
* ```gx_y1```
* ```gx_x2```
* ```gx_y2```
* ```gx_color```

_**Note:** This function requires graphics mode ```13h``` initalised with: ```gx_set_video_mode_gx```._

_**Note:** This function uses the ```AX```, ```BX``` and ```DI``` registers and Video Memory._

_Usage Example:_
```
; To draw a Green Square, 10 pixels wide.
mov gx_x1, 10 ; X1 = 10
mov gx_y1, 10 ; Y1 = 10
mov gx_x2, 10 ; X2 = 20
mov gx_y2, 10 ; Y2 = 20
mov gx_color, 47 ; Color = 10
call gx_rect
```

Utilities Library
-----------------

### Macros

#### movv to, from
To move the content of one memory variable to another.

_Usage Example:_
```
movv gx_x1, gx_x2
```

---

#### cmpv var1, var2, register
Compares two memory variables using a register for temprary storage.

_Usage Example:_
```
cmpv gx_x1, gx_x2, ax ; Compares gx_x1 and gx_x2 using the AX register
```

---

#### addv to, from
Adds two memory variables.

_Usage Example:_
```
addv gx_x1, gx_x2, ax
```

---

#### subv to, from
Subtracts two memory variables.

_Usage Example:_
```
subv gx_x1, gx_x2, ax
```

---

#### return code
Returns control to DOS returning the specified in the first argument code.

_Usage Example:_
```
return 0
```

---

#### save_registers
Pushes ```AX```, ```BX```, ```CX``` and ```DX``` to the stack.  
Can be later retrieved by: ```restore_registers```.

_Usage Example:_
```
mov ax, 10
mov bx, 20
save_registers
mov ax, 30
mov bx, 50
restore_registers
; AX is now 10 and BX is now 20
```

---

#### restore_registers
Pops ```AX```, ```BX```, ```CX``` and ```DX``` from the stack.

See: ```save_registers```.

_Usage Example:_
```
mov ax, 10
mov bx, 20
save_registers
mov ax, 30
mov bx, 50
restore_registers
; AX is now 10 and BX is now 20
```

### Functions

#### check_keypress
Checks for a keypress. Sets ```ZF``` if no keypress is available. Otherwise returns it's scan code into ```AH``` and it's ASCII code into ```AL```. Removes the character from the Type Ahead Buffer

_**Note:** This function uses the ```AX``` register._

_Usage Example:_
```
start:

mainloop:
  call check_keypress
  jz render 	; No keypress available - skip other instructions and render a frame
	cmp al, 27 	; Check if ASCII code of the key is 27 (ESC)
	je exit		  ; If so exit the program
  
render:
  ; Some Graphics code
  jmp mainloop
  
exit:
  return 0
```

License
-------
This library and it's supporting documentation are released under ```The MIT License (MIT)```.

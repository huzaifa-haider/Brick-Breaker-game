curserSet macro x_axis,y_axis

    MOV ah,02h
    MOV bx,0
    MOV dl, x_axis   ; horizental MOVement
    MOV dh,y_axis    ;vertical
    int 10h

endm



.model small
.stack 100h
.data
p1 dw 130
p2 dw 180

s1 dw 20
s2 dw 20
s3 dw 10  ;height
s4 dw 50   ; width
check1 dw 0
t1 dw 90
t2 dw 20
t3 dw 10  ;height
t4 dw 50   ; width
check2 dw 0
a1 dw 160
a2 dw 20
a3 dw 10  ;height
a4 dw 50   ; width
check3 dw 0
b1 dw 230
b2 dw 20
b3 dw 10  ;height
b4 dw 50   ; width
check4 dw 0
c1 dw 20
c2 dw 40
c3 dw 10  ;height
c4 dw 50   ; width
check5 dw 0
d1 dw 90
d2 dw 40
d3 dw 10  ;height
d4 dw 50   ; width
check6 dw 0
e1 dw 160
e2 dw 40
e3 dw 10  ;height
e4 dw 50   ; width
check7 dw 0
f1 dw 230
f2 dw 40
f3 dw 10  ;height
f4 dw 50   ; width
check8 dw 0

clr1 db 04h
clr2 db 0Ch
clr3 db 0Eh
clr4 db 09h
clr5 db 07h
clr6 db 06h
clr7 db 05h
clr8 db 03h

pdl_speed dw 07h 				
	
    WINDOW_WIDTH DW 130h				
	window_height DW 0F3h				
	consol_bound DW 6

    PADDLE_WIDTH DW 04h 				
	PADDLE_HEIGHT DW 4Ah				
	PADDLE_VELCITY DW 05h 				
    var1 DB 0 						

    BALL_ORIGINAL_X DW 150				
	BALL_ORIGINAL_Y DW 160 				
	BALL_X DW 150 						 
	BALL_Y DW 160 						
	BALL_SIZE DW 04h					
	BALL_VELOCITY_X DW 02h 				
	BALL_VELOCITY_Y DW 03h				
    
    bound1 dw 10
    bound2 dw 320
    bound3 dw 20
    bound4 dw 200

    score db 0d
    life db 3
    str1 db "Score: ", '$'
    str2 db "Lives: ", '$'
    str3 db "* Game Over *", '$'
    str4 db "Press ESC to return to main. ", '$'
    flag1 db 0
    flag2 db 0
    noLevel db 1
    str6 db "Level: ", '$'
    scoreList db 10 dup(0)

;.............................. menu data .........................

welcome db "........Welcome To Brick Breaker........$"
user_name db 20 dup('$')
newGame db "1.New Game$"
resume db "2.Resume$"
inst1 db "3.Instructions$"
HS db "4.High Scores$"
exiting db "0.Exit$"
for_main_menu db "9.Main Menu$"
x_val db 25
instructions db "you can play the game using arrow keys$"
enter_name db "Please Enter your name:$ "
high_score dw 2

;...............................menu data ends .....................
.code
main proc 
    MOV ax, @data
	MOV ds, ax
; paddle:
    MOV bx, 0
    MOV ax, 0
    MOV al, 13h
    int 10h 

start:    
	call videoMode
	call welcome_note
	call videoMode
    call mainMenu

l1:

    call clear 				

		refresh: 					
			MOV ah, 2ch					
			int 21h						;CH = hour CL = minute DH = second DL = 1/100 seconds

			cmp dl, var1				
			je refresh				

			
			MOV var1, dl 			
			call clear 			
cmp score, 8
je level2

cmp score, 24
je level3


level1:
    call tile1
    call tile2
    call tile3
    call tile4
    call tile5
    call tile6
    call tile7
    call tile8
    call draw_ball
    call move_ball
    call scorePrnt
    call draw_paddle
    call MOVe_paddle
    cmp life, 0
    je over 

    jmp l2

level2:
    call setlevel 
    call tile1
    call tile2
    call tile3
    call tile4
    call tile5
    call tile6
    call tile7
    call tile8
    call draw_ball
    call move_ball
    call scorePrnt
    call draw_paddle
    call move_paddle 

    cmp life, 0
    je over

    jmp l2

level3:
    call setlevel1
    call tile1
    call tile2
    call tile3
    call tile4
    call tile5
    call tile6
    call tile7
    call tile8
    call draw_ball
    call move_ball
    call scorePrnt
    call draw_paddle
    call move_paddle 

    cmp life, 0
    je over

    jmp l2

l2:
    jmp	refresh 

over:
    call clear
    MOV ah ,02h
    MOV bx, 0
    MOV dh, 05
    MOV dl, 05
    int 10h

    lea dx,str3
    MOV ah,9h
    int 21h

    MOV ah ,02h
    MOV bx, 0
    MOV dh, 07
    MOV dl, 05
    int 10h

    lea dx,str1
    MOV ah,9h
    int 21h

    MOV ah, 02h
    MOV dl, score
    add dl, "0"        
    int 21h

    MOV ah ,02h
    MOV bx, 0
    MOV dh, 17
    MOV dl, 10
    int 10h

    lea dx,str4
    MOV ah,9h
    int 21h

    call reset
    MOV life, 3

    MOV AH,01h
	INT 16h
	;JZ exit_func 
	MOV AH,00h
	INT 16h

	CMP  AL, 1Bh 							;check for 'Esc'
	Je   start

    
;ret
; exit:
; MOV ah, 4ch
; int 21h
main endp

setlevel proc

cmp flag1, 1
je exit

    inc noLevel
    neg BALL_VELOCITY_Y
    call RESET_BALL_POSITION
    add BALL_VELOCITY_X, 1
    add BALL_VELOCITY_Y, 1
    sub PADDLE_HEIGHT, 5h
    MOV clr1, 03h
    MOV clr2, 03h
    MOV clr3, 03h
    MOV clr4, 03h
    MOV clr5, 03h
    MOV clr6, 03h
    MOV clr7, 03h
    MOV clr8, 03h

    MOV check1, 3
    MOV check2, 3
    MOV check3, 3
    MOV check4, 3
    MOV check5, 3
    MOV check6, 3
    MOV check7, 3
    MOV check8, 3

inc flag1
exit:
ret
setlevel endp

setlevel1 proc

cmp flag2, 1
je exit
        inc noLevel
        neg BALL_VELOCITY_Y
        call RESET_BALL_POSITION
        add BALL_VELOCITY_X, 1
        add BALL_VELOCITY_Y, 1
        sub PADDLE_HEIGHT, 5h
        MOV clr1, 0Ch
        MOV clr2, 0Ch
        MOV clr3, 06h
        MOV clr4, 0Ch
        MOV clr5, 0Ch
        MOV clr6, 0Ch
        MOV clr7, 0Ch
        MOV clr8, 0Ch

        MOV check1, 7
        MOV check2, 7
        MOV check3, 7
        MOV check4, 7
        MOV check5, 7
        MOV check6, 7
        MOV check7, 7
        MOV check8, 7

inc flag2
exit:
ret
setlevel1 endp

reset proc

MOV score, 0

MOV check1, 0
MOV check2, 0
MOV check3, 0
MOV check4, 0
MOV check5, 0
MOV check6, 0
MOV check7, 0
MOV check8, 0

ret
reset endp


clear PROC  				

		MOV AH,00h 						
		MOV AL,13h 						
		INT 10h							

		MOV AH,0Bh						
		MOV BH,00h						
		MOV BL,00h 						
		INT 10h 						

		RET
clear ENDP

draw_paddle PROC 


        MOV cx, p1
        MOV dx, p2

		draw:
			MOV AH,0Ch
			MOV AL,0Fh					
			;MOV BH,00h			
			INT 10h 					

			INC CX 
			MOV ax,CX					
			SUB ax,p1		
			CMP ax, PADDLE_HEIGHT
			JNG draw

			MOV CX,p1 		
			INC DX 				
			MOV ax,DX					
			SUB ax,p2					
			CMP ax,PADDLE_WIDTH
			JNG draw


            ret
draw_paddle endp

move_paddle proc 				;process MOVement of paddles


		MOV AH,01h
		INT 16h
		JZ exit_func 	
;again:
		MOV AH,00h
		INT 16h

		CMP  AL, 1Bh 							; for 'Esc'
		JZ   exit 								
    
		CMP Ah, 4Bh 						;check for left key
		JE left

        cmp ah, 4Dh                         ;check for right key
        je right

        cmp ah, 48h
        je up

        cmp ah, 50h
        je down

        up:
        jmp exit_func

        down:
        jmp exit_func

        ;jne again


		left: 						
			MOV ax, pdl_speed 				
			SUB p1, ax 					

			MOV ax,consol_bound
			CMP p1, ax 					
			JL fix 		 
			JMP exit_func

			fix:
			MOV p1, ax 				
			JMP exit_func

		right: 						
			MOV ax,pdl_speed 					
			ADD p1, ax 					
			MOV ax, window_height

			CMP p1, ax 					
			JG fix2 		
			JMP exit_func

			fix2:
				MOV p1, ax 				
			    JMP exit_func

    exit_func:
            ret
        exit:
			JMP exit2 								;Jump to exit2
move_paddle endp

draw_ball PROC 				;procedure to draw the ball

		MOV CX, BALL_X 					;set the initial column (X)
		MOV DX, BALL_Y 					;set the initial line (Y)

		draw:
			MOV AH,0Ch					
			MOV AL, 02h					;choose green as color of the pixel
			;MOV BH,00h				
			INT 10h 				

			INC CX 						
			MOV ax,CX					
			SUB ax,BALL_X		
			CMP ax,BALL_SIZE 			
            JNG draw

			MOV CX,BALL_X 				
			INC DX 						
			MOV ax,DX					
			SUB ax,BALL_Y					
			CMP ax,BALL_SIZE 			
			JNG draw

		RET
draw_ball ENDP

move_ball PROC 					;process the MOVemment of the ball
    

l2:
		MOV ax,BALL_VELOCITY_X
		sub BALL_X,ax 					;MOVe the ball horizontally

		MOV ax,bound1
		CMP BALL_X,ax 					;BALL_X is compared with the left boundaries of the screen
		JL NEG_VELOCITY_X 				;if it is less, reverse

		MOV ax,bound2
		SUB ax,BALL_SIZE
		SUB ax,consol_bound
		CMP BALL_X,ax					;BALL_Y is compared with the right boundaries of the screen
		JG NEG_VELOCITY_X 				;if it is greater, reverse

		;MOVe the ball vertically
		MOV ax,BALL_VELOCITY_Y
		sub BALL_Y,ax 			


		MOV ax,bound3
		CMP BALL_Y,ax					;BALL_Y is compared with the top boundaries of the screen	
		JL NEG_VELOCITY_Y				;if its less reverse the velocity in Y


		MOV ax,bound4
		SUB ax,BALL_SIZE
		SUB ax,consol_bound					
		CMP BALL_Y,ax					;BALL_Y is compared with the bottom boundaries of the screen
		JG RESET_POSITION				;if its greater reverse the velocity in Y

        ;MOV ax, PADDLE_HEIGHT
        MOV ax, BALL_Y
        MOV bx, p2
        MOV cx, BALL_X
        MOV dx, PADDLE_WIDTH
        ;MOV si, offset BALL_Y

;.while 
        .if(cx >= p1 && (cx <= [p1 + dx]) && (ax >=  bx) )
        neg BALL_VELOCITY_Y
        .endif

		 RET 									;exit this procedure

		RESET_POSITION:
			CALL RESET_BALL_POSITION	;reset ball position to the center of the screen
            ;jmp l2
            dec life                    ;decrese life when ball misses the paddle
            neg BALL_VELOCITY_Y
        	RET

		NEG_VELOCITY_Y:
			NEG BALL_VELOCITY_Y			
			RET

        NEG_VELOCITY_X:
        NEG BALL_VELOCITY_X 					;reverse the ball horizontall velocity
		RET

		EXIT_BALL_COLLISION:
		RET

move_ball ENDP

tile1 proc
        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3
        l1:
        cmp check1, 1
        je exit
        jne do
        l2:
        cmp check1, 4
        je change
        cmp check1, 5
        je exit
        jne do
        l3:
        cmp check1, 8
        je change2
        cmp check1, 9
        je change3
        cmp check1, 10
        je exit
        jne do 
do:
        MOV cx, s1
        MOV dx, s2

		draw:
			MOV AH,0Ch					
			MOV AL,clr1					
			;MOV BH,00h					
			INT 10h 					

			INC CX 						
			MOV ax,CX					
			SUB ax, s1		
			CMP ax, s4
			JNG draw

			MOV CX, s1 		
			INC DX 						
			MOV ax,DX					
			SUB ax, s2					
			CMP ax,s3
			JNG draw

            jmp here 

            change:
            ;NEG BALL_VELOCITY_Y			
            MOV clr1, 02h 
            jmp do

            change2:
            MOV clr1, 0Eh
            jmp do

            change3:
            MOV clr1, 0Fh
            jmp do
;push ax
here:
        MOV ax,s1
		ADD ax,s4
		CMP BALL_X,ax
		JNL exit				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,s1
		JNG exit					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,s2
		JNG exit				;if there is no collision exit the procedure

		MOV ax,s2
		ADD ax,s3
		CMP BALL_Y,ax
		JNL exit

            inc check1
            inc score
			NEG BALL_VELOCITY_Y

            ret
;pop ax
        	NEG_VELOCITY_Y:
            inc check1
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            exit:
            ret
tile1 endp

tile2 proc
        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3

        l1:
        cmp check2, 1
        je exit
        jne do
        l2:
        cmp check2, 4
        je change
        cmp check2, 5
        je exit
        jne do
        l3:
        cmp check2, 8
        je change2
        cmp check2, 9
        je change3
        cmp check2, 10
        je exit
        jne do        
			;set the initial line (Y)
do:
        MOV cx, t1
        MOV dx, t2

		draw:
			MOV AH,0Ch					
			MOV AL,clr2					
			;MOV BH,00h					
			INT 10h 					

			INC CX 						
			MOV ax,CX					
			SUB ax, t1		
			CMP ax, t4
			JNG draw

			MOV CX, t1 		
			INC DX 						
			MOV ax,DX					
			SUB ax, t2					
			CMP ax,t3
			JNG draw
;push ax
            jmp here 

            change:
            ;NEG BALL_VELOCITY_Y			
            MOV clr2, 02h 
            jmp do

            change2:
            MOV clr2, 0Eh
            jmp do

            change3:
            MOV clr2, 0Fh
            jmp do

;push ax
here:
        MOV ax,t1
		ADD ax,t4
		CMP BALL_X,ax
		JNL EXIT				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,t1
		JNG EXIT					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,t2
		JNG EXIT				;if there is no collision exit the procedure

		MOV ax,t2
		ADD ax,t3
		CMP BALL_Y,ax
		JNL EXIT

            inc check2
            inc score
			NEG BALL_VELOCITY_Y


            ret
;pop ax
        	NEG_VELOCITY_Y:
            inc check2
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            EXIT:
            ret
tile2 endp

tile3 proc

        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3

        l1:
        cmp check3, 1
        je exit
        jne do
        l2:
        cmp check3, 4
        je change
        cmp check3, 5
        je exit
        jne do
        l3:
        cmp check3, 8
        je change2
        cmp check3, 9
        ; je change3
        ; cmp check3, 10
        je exit
        jne do 
			;set the initial line (Y)
do:
        MOV cx, a1
        MOV dx, a2

		draw:
			MOV AH,0Ch					
			MOV AL,clr3					
			MOV BH,00h					
			INT 10h 					

			INC CX 						
			MOV ax,CX					
			SUB ax, a1		
			CMP ax, a4
			JNG draw

			MOV CX, a1 		
			INC DX 						
			MOV ax,DX					
			SUB ax, a2					
			CMP ax,a3
			JNG draw
;push ax
            jmp here 

            change:
            ;NEG BALL_VELOCITY_Y			
            MOV clr3, 02h 
            jmp do

            change2:
            ;MOV clr3, 0Eh
            mov check6, 10
            mov check2, 10
            mov check5, 10
            inc check3
            jmp do

            change3:
            MOV clr3, 0Fh
            jmp do

;push ax
here:
        MOV ax,a1
		ADD ax,a4
		CMP BALL_X,ax
		JNL EXIT				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,a1
		JNG EXIT					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,a2
		JNG EXIT				;if there is no collision exit the procedure

		MOV ax,a2
		ADD ax,a3
		CMP BALL_Y,ax
		JNL EXIT

            inc check3
            inc score
			NEG BALL_VELOCITY_Y


            ret
;pop ax
        	NEG_VELOCITY_Y:
            inc check3
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            EXIT:
            ret
tile3 endp

tile4 proc

        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3

        l1:
        cmp check4, 1
        je exit
        jne do

        l2:
        cmp check4, 4
        je change
        cmp check4, 5
        je exit
        jne do

        l3:
        cmp check4, 8
        je change2
        cmp check4, 9
        je change3
        cmp check4, 10
        je exit
        jne do 
			;set the initial line (Y)
do:
        MOV cx, b1
        MOV dx, b2

		draw:
			MOV AH,0Ch					
			MOV AL,clr4					
			MOV BH,00h					
			INT 10h 					

			INC CX 						
			MOV ax,CX					
			SUB ax, b1		
			CMP ax, b4
			JNG draw

			MOV CX, b1 		
			INC DX 						
			MOV ax,DX					
			SUB ax, b2					
			CMP ax,b3
			JNG draw

            jmp here 

            change:
            MOV clr4, 02h
            jmp do

            change2:
            MOV clr4, 0Eh
            jmp do

            change3:
            MOV clr4, 0Fh
            jmp do
           
;push ax
here:

        MOV ax,b1
		ADD ax,b4
		CMP BALL_X,ax
		JNL exit				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,b1
		JNG exit					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,b2
		JNG exit				;if there is no collision exit the procedure

		MOV ax,b2
		ADD ax,b3
		CMP BALL_Y,ax
		JNL exit

            inc check4
            inc score
			NEG BALL_VELOCITY_Y


            ret
;pop ax
        	NEG_VELOCITY_Y:
            inc check4
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            exit:
            ret
tile4 endp

tile5 proc
        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3

        l1:
        cmp check5, 1
        je exit
        jne do
        l2:
        cmp check5, 4
        je change
        cmp check5, 5
        je exit
        jne do

        l3:
        cmp check5, 8
        je change2
        cmp check5, 9
        je change3
        cmp check5, 10
        je exit
        jne do         
			;set the initial line (Y)
do:
        MOV cx, c1
        MOV dx, c2

		draw:
			MOV AH,0Ch					
			MOV AL,clr5					
			MOV BH,00h					
			INT 10h 					

			INC CX 						
			MOV ax,CX					
			SUB ax, c1		
			CMP ax, c4
			JNG draw

			MOV CX, c1 		 
			INC DX 					
			MOV ax,DX				
			SUB ax, c2					
			CMP ax,c3
			JNG draw
;push ax
            jmp here 

            change:		
            MOV clr5, 02h 
            jmp do

            change2:
            MOV clr5, 0Eh
            jmp do

            change3:
            MOV clr5, 0Fh
            jmp do

;push ax
here:

        MOV ax,c1
		ADD ax,c4
		CMP BALL_X,ax
		JNL exit				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,c1
		JNG exit					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,c2
		JNG exit				;if there is no collision exit the procedure

		MOV ax,c2
		ADD ax,c3
		CMP BALL_Y,ax
		JNL exit

            inc check5
            inc score
			NEG BALL_VELOCITY_Y


            ret
;pop ax
        	NEG_VELOCITY_Y:
            inc check5
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            exit:
            ret
tile5 endp

tile6 proc

        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3

        l1:
        cmp check6, 1
        je exit
        jne do
        l2:
        cmp check6, 4
        je change
        cmp check6, 5
        je exit
        jne do

        l3:
        cmp check6, 8
        je change2
        cmp check6, 9
        je change3
        cmp check6, 10
        je exit
        jne do
			
do:
        MOV cx, d1
        MOV dx, d2

		draw:
			MOV AH,0Ch					
			MOV AL,clr6					
			MOV BH,00h					
			INT 10h 					

			INC CX 						
            MOV ax,CX					
			SUB ax, d1		
			CMP ax, d4
			JNG draw

			MOV CX, d1 		
			INC DX 						
			MOV ax,DX					
			SUB ax, d2					
			CMP ax,d3
			JNG draw
;push ax
            jmp here 

            change:
            ;NEG BALL_VELOCITY_Y			
            MOV clr6, 02h 
            jmp do

            change2:
            MOV clr6, 0Eh
            jmp do

            change3:
            MOV clr6, 0Fh
            jmp do

;push ax
here:

        MOV ax,d1
		ADD ax,d4
		CMP BALL_X,ax
		JNL exit				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,d1
		JNG exit					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,d2
		JNG exit				;if there is no collision exit the procedure

		MOV ax,d2
		ADD ax,d3
		CMP BALL_Y,ax
		JNL exit

            inc check6
            inc score
			NEG BALL_VELOCITY_Y


            ret
;pop ax
        	NEG_VELOCITY_Y:
            
            inc check6
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            exit:
            ret
tile6 endp

tile7 proc
        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3
        l1:
        cmp check7, 1
        je exit
        jne do
        l2:
        cmp check7, 4
        je change
        cmp check7, 5
        je exit
        jne do

        l3:
        cmp check7, 8
        je change2
        cmp check7, 9
        je change3
        cmp check7, 10
        je exit
        jne do 

do:
        MOV cx, e1
        MOV dx, e2

		draw:
			MOV AH,0Ch					
			MOV AL,clr7					
			MOV BH,00h					
			INT 10h 					

			INC CX 						
			MOV ax,CX					
			SUB ax, e1		
			CMP ax, e4
			JNG draw

			MOV CX, e1 		
			INC DX 						
			MOV ax,Dx					
			SUB ax, e2					
			CMP ax,e3
			JNG draw
;push ax
            jmp here 

            change:
            MOV clr7, 02h 
            jmp do

            change2:
            MOV clr7, 0Eh
            jmp do

            change3:
            MOV clr7, 0Fh
            jmp do

here:

        MOV ax,e1
		ADD ax,e4
		CMP BALL_X,ax
		JNL exit				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,e1
		JNG exit					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,e2
		JNG exit				;if there is no collision exit the procedure

		MOV ax,e2
		ADD ax,e3
		CMP BALL_Y,ax
		JNL exit

            inc check7
            inc score
			NEG BALL_VELOCITY_Y


            ret
;pop ax
        	NEG_VELOCITY_Y:
            inc check7
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            exit:
            ret
tile7 endp

tile8 proc
        cmp noLevel, 1
        je l1
        cmp noLevel, 2
        je l2
        cmp nolevel, 3
        je l3
       
        l1:
        cmp check8, 1
        je exit
        jne do
        l2:
        cmp check8, 4
        je change
        cmp check8, 5
        je exit
        jne do

        l3:
        cmp check8, 8
        je change2
        cmp check8, 9
        je change3
        cmp check8, 10
        je exit
        jne do        
			;set the initial line (Y)
do:
        MOV cx, f1
        MOV dx, f2

		draw:
			MOV AH,0Ch					
			MOV AL,clr8					
			MOV BH,00h					
			INT 10h 					

			INC CX 						
			MOV ax,CX					
			SUB ax, f1		
			CMP ax, f4
			JNG draw

			MOV CX, f1 		
			INC DX 						
            MOV ax, dx					
			SUB ax, f2					
			CMP ax,f3
			JNG draw
;push ax
            jmp here 

            change:
            MOV clr8, 02h 
            jmp do

            change2:
            MOV clr8, 0Eh
            jmp do

            change3:
            MOV clr8, 0Fh
            jmp do

;push ax
here:

        MOV ax,f1
		ADD ax,f4
		CMP BALL_X,ax
		JNL exit				;if there is no collision exit the procedure

		MOV ax,BALL_X
		ADD ax,BALL_SIZE
		CMP ax,f1
		JNG exit					;if there is no collision exit the procedure

		MOV ax,BALL_Y
		ADD ax,BALL_SIZE
		CMP ax,f2
		JNG exit				;if there is no collision exit the procedure

		MOV ax,f2
		ADD ax,f3
		CMP BALL_Y,ax
		JNL exit

            inc check8
            inc score
			NEG BALL_VELOCITY_Y


            ret
;pop ax
        	NEG_VELOCITY_Y:
            inc check8
            inc score
			NEG BALL_VELOCITY_Y			
			RET
            exit:
            ret
tile8 endp

scorePrnt proc

    MOV ah ,02h
    MOV bx, 0
    MOV dh, 01
    MOV dl, 01
    int 10h

    lea dx,str1
    MOV ah,9h
    int 21h

;     cmp score, 10
;     jg l1
;     jmp l22

; l1:
;     MOV al, score
;     MOV bl, 10
;     div al

; MOV cl, al
; MOV ch, ah

; l2:
;     MOV ah, 02h
;     MOV dl, cl
;     add dl, "0"        
;     int 21h

;     MOV ah, 02h
;     MOV dl, ch
;     add dl, "0"        
;     int 21h

    ;jmp l3

l22:
    MOV ah, 02h
    MOV dl, score
    add dl, "0"        
    int 21h

l3: 
    MOV ah ,02h
    MOV bx, 0
    MOV dh, 01
    MOV dl, 30
    int 10h

    lea dx,str2
    MOV ah,9h
    int 21h

    MOV ah, 02h
    MOV dl, life
    add dl, "0"        
    int 21h

    ;dot 20,50
    MOV ah ,02h
    MOV bx, 0
    MOV dh, 01
    MOV dl, 15
    int 10h

    lea dx,str6
    MOV ah,9h
    int 21h

    MOV ah, 02h
    MOV dl, nolevel
    add dl, "0"        
    int 21h    

ret
scorePrnt endp

RESET_BALL_POSITION PROC  		;restart ball position to the center of the screen

		MOV ax,BALL_ORIGINAL_X 			
		MOV BALL_X,ax 					

		MOV ax,BALL_ORIGINAL_Y
		MOV BALL_Y,ax 					

		RET
RESET_BALL_POSITION ENDP

mainMenu proc
	call videoMode
    curserSet x_val,5          ;macro for alignemnt
    MOV si,offset welcome
    push si                         
    call stringDisplay          ;display proc for displaying string

    call nextLine               ;proc for next line 
 
    curserSet x_val,6          ;macro for alignemnt

    MOV si,offset newGame
    push si
    call stringDisplay

    call nextLine               ;proc for next line 

    curserSet x_val,7          ;macro for alignemnt
    MOV si,offset resume
    push si
    call stringDisplay

    curserSet x_val,8          ;macro for alignemnt    
    MOV si,offset inst1
    push si
    call stringDisplay

    call nextLine               ;proc for next line 

    curserSet x_val,9          ;macro for alignemnt
    MOV si,offset HS
    push si
    call stringDisplay

    call nextLine               ;proc for next line 
    curserSet x_val,10          ;macro for alignemnt
    MOV si,offset exiting
    push si
    call stringDisplay

    call menuInput
    




    ret
mainMenu endp

stringDisplay proc
    pop di
    pop si
    
    
    lea dx,[si]
    MOV ah,09h
    int 21h
    push di
    ret
stringDisplay endp

nextLine proc
    MOV ah,02h
    MOV dl,10
    int 21h
    ret

nextLine endp

videoMode proc      ;procedure for setting video mode

    MOV ah,00h		
    MOV al,3h		
    Int 10h


    ret
videoMode endp
welcome_note proc			;procedure for welcome note and take user name
	curserSet x_val,5
	MOV si,offset welcome
    push si                         
    call stringDisplay          ;display proc for displaying string
	
	curserSet x_val,6
	MOV si,offset enter_name
    push si                         
    call stringDisplay          ;display proc for displaying string

	 MOV si,offset user_name
    MOV bx,0
    .while(bx<20 && al!=13)      
        MOV ah,01h
        int 21H

        MOV [si+bx],al
        inc bx


    .endw

	ret
welcome_note endp

menuInput proc
    again:
    MOV ah,01h
    int 16h
    jz next
    jmp again
    
    next:
	call nextLine
    MOV ah,00h
    int 16h
    cmp al,'1'
    je call_newGame
    cmp al,'2'
    je call_resume
    cmp al,'3'
    je call_instruction
    cmp al,'4'
    je call_H_Score
    cmp al,'0'
    je call_exit
    
    call_newGame:

    jmp last
    call_resume:
    jmp last
    call_instruction:
		call videoMode
		curserSet 10,10

		lea dx,instructions
		MOV ah,09h
		int 21h
		second_phase_menu:
			curserSet 10,11
			lea dx,for_main_menu
			MOV ah,09h
			int 21H
			
			curserSet 10,12
			lea dx,exiting
			MOV ah,09h
			int 21H	
			again1:
				MOV ah,01h
				int 16h
				jz next1
				jmp again1
				
				next1:
					call nextLine
					MOV ah,00h
					int 16h
					cmp al,'0'
					je exit2
					cmp al,'9'
					je call_main_menu

				call_main_menu:
					call mainMenu

		MOV ah,4ch
		int 21h
		
    call_H_Score:
	MOV ah,02h
	MOV dx,high_score
	add dx,"0"
	int 21h
    jmp second_phase_menu
    call_exit:
    jmp exit2




last:
    ret
menuInput endp

exit2: 								;the procedure to exit the game by clearing the screen
	  	MOV AH,00h 						;clearing the screen
  	  	MOV AL,02h						;loading the default video mode of dos
  	  	INT 10h 
		MOV AH, 4Ch 					;exit the porgram
		MOV AL, 00h
		INT 21H


end main



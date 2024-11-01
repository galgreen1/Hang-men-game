;author: GAL GREEN ID 214883415


.MODEL SMALL
.STACK 100h
;data section
.DATA
    win_sign dw 0; help varible to check if the user won on the last game
	guess1 db 'SHALOM', '$'  ; first word to guess
	guess2 db 'GOBLINS', '$' ;second word to guess
	guess1_size dw 6 ;SHALOM is 6 letters 
	guess1_help_array db 6 dup(' ') ; help array
	guess2_help_array db 7 dup(' ') ; help array
	guess2_size db 7; 7 letters
	Guessed1 db 0 ;bolean if the word was fully guessed: 1 means guessed 0 no
    guess_array db 6 dup(' ') ; array to store the words the player guessed correct
    guess_array2 db 20 dup(' ') ; array to store the words the player guessed correct from word 2
	headline db 'Guess the word!','$' ;  headline in the game- to guess the word
    quesname db 'what is your name? type enter in his end','$' ; ask the player his name
    buffer db 128 dup('$') ; a buffer to keep player name 
    hellow db 'HELLO :','$'
     ; rows that will be written in the start of the game- hello and instructions
    welw db 'WELCOME TO HANG-MEN GAME!','$'
    instr1 db 'In this game, you need to guess a secret word!','$'
    instr11 db 'In each try you try to guess one letter','$'
    instr2 db 'if the letter is in the word:','$'
    instr21 db 'You will see where it is in the word, else you would lose a life','$'
    instr3 db 'pay attention- you only have a certain amount of life, try not to die :)','$'
    readyq db 'ready to start the game?? press enter when you do!','$'
    clearRow db 80 dup(' '),'$'; blank row- in order to clean all the instructions rows
	level dw 1; varible to tell which level
	TIME_OVER db 'TIME OVER','$'
	flag_time dw 0
	
	; Define variable to count timer ticks
	start_ticks dd 0
	end_ticks dd 0
	elapsed db 0

    underline db '_',' ','$'  ; underline 

    instrgame db 'each underline represent 1 char in the secret word:   ','$'
    guesschar db 'guess one char you think is in the word !','$'
    ;to save the life of the player
    life dw 0
    count dw 0
    space db ' ','$'
	countlose dw 0

;parts for the hang men drawing	
	
	hangman1 db' rEPPKqIIXqKK5Ls2Jr ',0Dh,0Ah 
   db':rrrr:JB:iiiBB7 BB ',0Dh,0Ah 
     db'     U     rBrBB ',0Dh,0Ah 
     db'     2       SBB ',0Dh,0Ah 
     db'   vPBY       BB ',0Dh,0Ah 
     db' .B.  rQ.     BQ ',0Dh,0Ah 
     db' 5g    BY     BB ',0Dh,0Ah 
     db'  ds: vX      BB ',0Dh,0Ah 
	 db '$'
	 
	 hangman2  db'    LR        QB ',0Dh,0Ah 
     db'    KB        BQ ',0Dh,0Ah 
     db'   BBBB:      QB ',0Dh,0Ah 
	 db '$'
	 
	 hangman3 db' :Br Y QE     BB ',0Dh,0Ah 
     db' B: .P  Qr    BB ',0Dh,0Ah 
     db'    :K        BQ ',0Dh,0Ah 
	 db '$'
	 
	 hangman4 db'    BB.       BB ',0Dh,0Ah 
     db'   BL.B7      BB ',0Dh,0Ah 
     db' :Bv   Bq     BB ',0Dh,0Ah 
    db' iBg    iBY   BB ',0Dh,0Ah 
	db '$'
	
	 hangman5  db'              BB ',0Dh,0Ah 
    db'              BB ',0Dh,0Ah 
    db'              BB ',0Dh,0Ah 
    db'              BB ',0Dh,0Ah 
    db'              BB ',0Dh,0Ah 
    db'              BX ',0Dh,0Ah 
	db '$'
	
	

	         
.CODE

 
;check if the first word was fully guessed- if yes will turn the bolean Guessed1 to 1
; We will check if the amount of letters the user guessed right equal to the size of the word
CheckGuess1 PROC
    push cx
    mov cx, 6                ; Set loop counter to 6 (for 6 letters)
    lea si, guess1_help_array      ; Load the address of the array into SI

CheckLettersLoop:
    mov bx,0 ;bolean if win got called
    mov al, [si]             ; Load the current character from the array into AL
    cmp al, ' '              ; Compare the character to a space (empty value)
    je  IncompleteWord       ; If the character is a space, jump to IncompleteWord

    inc si                   ; Move to the next array element
    loop CheckLettersLoop    ; Repeat the loop until all 6 elements are checked
	
	

CompleteWord:
    ; Code to execute if all 6 elements contain letters
    ;all letters were guessed
	pop cx
    call Win 
	
	;pop cx is needed only if win didnt get called
	

IncompleteWord:
    ; Code to execute if not all elements are filled with letters 
	cmp bx,1
	je final
	pop cx
	
final:	
	ret

ret
CheckGuess1 ENDP

;check if the second word was fully guessed
CheckGuess2 PROC
    push cx
    mov cx, 7                ; Set loop counter to 7 (for 7 letters)
    lea si, guess2_help_array      ; Load the address of the array into SI

CheckLettersLoop2:
    mov bx,0 ;bolean if win got called
    mov al, [si]             ; Load the current character from the array into AL
    cmp al, ' '              ; Compare the character to a space (empty value)
    je  IncompleteWord2       ; If the character is a space, jump to IncompleteWord

    inc si                   ; Move to the next array element
    loop CheckLettersLoop2    ; Repeat the loop until all 6 elements are checked
	
	

CompleteWord2:
    ; Code to execute if all 6 elements contain letters
    ;all letters were guessed
    call Win 
	
	;pop cx is needed only if win didnt get called
	

IncompleteWord2:
    ; Code to execute if not all elements are filled with letters 
	cmp bx,1
	je final2
	pop cx
	
final2:	
	ret

;ret
CheckGuess2 ENDP

;when the user win we will open winner image in graphic mode
Win PROC
       mov [win_sign],1 ; the user won
    ; clean the screen
		 ; clean page 0
       mov ax, 0600h      ; 
       mov bh, 07h        ; 
       mov cx, 0000h      ; start point of screen
       mov dx, 184Fh      ; end point of screen
       mov bP, 00h        ; page 0
       int 10h            ; clean all

        ; clean page 1
       mov ax, 0600h     
       mov bh, 07h         
       mov cx, 0000h      ; start point of screen
       mov dx, 184Fh      ; end point of screen
       mov bP, 01h        ; page 1
       int 10h            ; clean all
;Win image pop up
	    ; graphic screen
        mov ax, 13h
        int 10h
		
		;print W
		;print \
	   mov cx, 50          ; loop times
       mov ax,10 ; x cord
       mov bx, 30        ; y cord
; go down and right every loop
DrawleftWLine:
    push cx
	push ax
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    pop cx ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	inc cx
	mov ax,cx
	pop cx
	loop DrawleftWLine
	
		;print short /
	   mov cx, 25          ; loop times
       mov ax,60 ; x cord
       mov bx, 80        ; y cord
; go up and right every loop
DrawRightLWLine:
    push cx
	push ax
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    pop cx ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	dec bx
	inc cx
	mov ax,cx
	pop cx
	loop DrawRightLWLine
		
		;print short \
	   mov cx, 25          ; loop times
       mov ax,85 ; x cord
       mov bx, 55        ; y cord
; go down and right every loop
DrawRightWLine:
    push cx
	push ax
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    pop cx ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	inc cx
	mov ax,cx
	pop cx
	loop DrawRightWLine
	
		;print /
	   mov cx, 50          ; loop times
       mov ax,110 ; x cord
       mov bx, 80        ; y cord
; go up and right every loop
DrawRightRWLine:
    push cx
	push ax
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    pop cx ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	dec bx
	inc cx
	mov ax,cx
	pop cx
	loop DrawRightRWLine
		
		;print I
		;print -
	   mov cx, 30         ; loop times
       mov dx, 30         ; y cord

       mov bx, 170        ; x cord

DrawsLineI1:
    push cx
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 30      
    int 10h              
	inc bx
	pop cx
	loop DrawsLineI1
	
		;print |
	   mov cx, 50          ; loop times
       mov bx, 30        ; y cord

DrawILine:
    push cx
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    mov cx, 185 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawILine
		
		;print -
	   mov cx, 30         ; loop times
       mov dx, 80        ; y cord

       mov bx, 170        ; x cord

DrawsLineI2:
    push cx
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 80      
    int 10h              
	inc bx
	pop cx
	loop DrawsLineI2
		
		
		;print N
		;print |
	   mov cx, 50          ; loop times
       mov bx, 30        ; y cord

DrawN1Line:
    push cx
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    mov cx, 205 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawN1Line
		;print \
	   mov cx, 50          ; loop times
       mov ax,205 ; x cord
       mov bx, 30        ; y cord
; go down and right every loop
DrawNLine:
    push cx
	push ax
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    pop cx ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	inc cx
	mov ax,cx
	pop cx
	loop DrawNLine
		
		
		;print |
		mov cx, 50          ; loop times
       mov bx, 30        ; y cord

DrawN2Line:
    push cx
    mov al, 0Eh            ; color:yellow
    mov ah, 0Ch      
    mov cx, 255 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawN2Line

     
	
	

    ;wait for press a char to get out
    mov ah, 00h
    int 16h
	
	 ; Clear the graphic screen (fill with black)
    mov ax, 0A000h       ; Base address of video memory
    mov es, ax
    xor di, di           ; Point to the start of video memory

    ; Clear the screen by filling video memory with 0s
    mov cx, 32000        ; Number of iterations needed (320x200/2 bytes)
ClearScreenLoop:
    mov byte ptr es:[di], 0  ; Write 0 (black) to video memory
    inc di                   ; Move to the next pixel
    loop ClearScreenLoop     ; Repeat until CX reaches 0
	
	; Return to text mode
    mov ah, 0
    mov al, 2
    int 10h
	
	mov bx,1 ;bolean if win got called
    
	
	mov ax,level
	cmp AX,1
	je jmp_End1
	
jmp_End2:
    jmp End2
	;jmp End_final
	
jmp_End1:
    jmp End1
	ret
	
End_final:
    ret	
	
	



;jmp End1
;ret
 
Win ENDP    

;when the user lose we will open loser image in graphic mode
Loser PROC

        ; clean the screen
		 ; clean page 0
       mov ax, 0600h      ; 
       mov bh, 07h        ; 
       mov cx, 0000h      ; start point of screen
       mov dx, 184Fh      ; end point of screen
       mov bP, 00h        ; page 0
       int 10h            ; clean all

        ; clean page 1
       mov ax, 0600h     
       mov bh, 07h         
       mov cx, 0000h      ; start point of screen
       mov dx, 184Fh      ; end point of screen
       mov bP, 01h        ; page 1
       int 10h            ; clean all
;lose image pop up
	    ; graphic screen
        mov ax, 13h
        int 10h

      ; Print L  
	  ;print |
	   mov cx, 60          ; loop times

       mov bx, 30        ; y cord

DrawFLine:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, 10 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawFLine
	  
	  ;print -
       mov cx, 30         ; loop times
       mov dx, 90         ; y cord

       mov bx, 10        ; x cord

DrawsLine:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 90       
    int 10h              
	inc bx
	pop cx

    
    loop DrawsLine
	
	 ; Print O
	  ;print first quarter of O
	   mov cx, 30        ; loop times
       mov ax,70 ; x cord
       mov bx, 30        ; y cord
; we will go one pixel down and left for drawing quarter O
DrawQ1O:
    push cx
	push ax
    mov al, 4            ; color:red
    mov ah, 0Ch      
	pop cx ; x cord 
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	mov ax,cx
    dec ax  
	pop cx

    loop DrawQ1O
	
	;print second quarter of O
	   mov cx, 30        ; loop times
       mov ax,40 ; x cord
       mov bx, 60        ; y cord
; we will go one pixel down and right for drawing quarter O
DrawQ2O:
    push cx
	push ax
    mov al, 4            ; color:red
    mov ah, 0Ch      
	pop cx ; x cord 
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	mov ax,cx
    inc ax  
	pop cx


    loop DrawQ2O
	
	;print third quarter of O
	   mov cx, 30        ; loop times
       mov ax,70 ; x cord
       mov bx, 90        ; y cord
; we will go one pixel up and right for drawing quarter O
DrawQ3O:
    push cx
	push ax
    mov al, 4            ; color:red
    mov ah, 0Ch      
	pop cx ; x cord 
	mov dx, bx ; y cord        
    int 10h              
	dec bx
	mov ax,cx
    inc ax  
	pop cx

    loop DrawQ3O
	
	;print last quarter of O
	   mov cx, 30        ; loop times
       mov ax,100 ; x cord
       mov bx, 60        ; y cord
; we will go one pixel up and left for drawing quarter O
DrawQ4O:
    push cx
	push ax
    mov al, 4            ; color:red
    mov ah, 0Ch      
	pop cx ; x cord 
	mov dx, bx ; y cord        
    int 10h              
	dec bx
	mov ax,cx
    dec ax  
	pop cx


    loop DrawQ4O
	
	;print S
	;print |
	   mov cx, 30          ; loop times

       mov bx, 30        ; y cord

DrawF1Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, 105 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawF1Line
	  
	  ;print -
       mov cx, 25         ; loop times
       mov dx, 30         ; y cord

       mov bx, 105       ; x cord

Draws1Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 30       
    int 10h              
	inc bx
	pop cx

    
    loop Draws1Line
	
	;print |
	   mov cx, 30          ; loop times

       mov bx, 60        ; y cord

DrawF2Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, 130 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawF2Line
	  
	  ;print -
       mov cx, 25         ; loop times
       mov dx, 60         ; y cord

       mov bx, 105       ; x cord

Draws2Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 60       
    int 10h              
	inc bx
	pop cx

    
    loop Draws2Line
	

    ;print -	
	mov cx, 25         ; loop times
       mov dx, 60         ; y cord

       mov bx, 105       ; x cord

Draws3Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 90       
    int 10h              
	inc bx
	pop cx

    
    loop Draws3Line
	
	;print E
	
	;print |
	   mov cx, 30          ; loop times

       mov bx, 30        ; y cord

DrawE1Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, 140 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawE1Line
	  
	  ;print -
       mov cx, 25         ; loop times
       mov dx, 30         ; y cord

       mov bx, 140       ; x cord

DrawsE1Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 30       
    int 10h              
	inc bx
	pop cx

    
    loop DrawsE1Line
	
		;print |
	   mov cx, 30          ; loop times

       mov bx, 60        ; y cord

DrawE2Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, 140 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawE2Line
	  
	  ;print - shorter
       mov cx, 15         ; loop times
       mov dx, 60         ; y cord

       mov bx, 140       ; x cord

DrawsE2Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 60       
    int 10h              
	inc bx
	pop cx

    
    loop DrawsE2Line
	
	  
	  ;print - 
       mov cx, 25         ; loop times
       mov dx, 90         ; y cord

       mov bx, 140       ; x cord

DrawE3Line:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, bx           
	mov dx, 90       
    int 10h              
	inc bx
	pop cx

    
    loop DrawE3Line
	
	;print R
	;print | 
	   mov cx, 60          ; loop times

       mov bx, 30        ; y cord

DrawRLine:
    push cx
    mov al, 4            ; color:red
    mov ah, 0Ch      
    mov cx, 180 ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	pop cx

    
    loop DrawRLine
	
	;print half circle
	;print third quarter of O
	   mov cx, 20        ; loop times
       mov ax,180 ; x cord
       mov bx, 70        ; y cord
; we will go one pixel up and right for drawing quarter O
DrawQ3R:
    push cx
	push ax
    mov al, 4            ; color:red
    mov ah, 0Ch      
	pop cx ; x cord 
	mov dx, bx ; y cord        
    int 10h              
	dec bx
	mov ax,cx
    inc ax  
	pop cx

    loop DrawQ3R
	
	;print last quarter of O
	   mov cx, 20        ; loop times
       mov ax,200 ; x cord
       mov bx, 50        ; y cord
; we will go one pixel up and left for drawing quarter O
DrawQ4R:
    push cx
	push ax
    mov al, 4            ; color:red
    mov ah, 0Ch      
	pop cx ; x cord 
	mov dx, bx ; y cord        
    int 10h              
	dec bx
	mov ax,cx
    dec ax  
	pop cx


    loop DrawQ4R
	
	;print \
	   mov cx, 20          ; loop times
       mov ax,180 ; x cord
       mov bx, 70        ; y cord
; go down and right every loop
DrawleftRLine:
    push cx
	push ax
    mov al, 4            ; color:red
    mov ah, 0Ch      
    pop cx ;x cord          
	mov dx, bx ; y cord        
    int 10h              
	inc bx
	inc cx
	mov ax,cx
	pop cx
	loop DrawleftRLine
	
	

    ;wait for press a char to get out
    mov ah, 00h
    int 16h
	
	 ; Clear the graphic screen (fill with black)
    mov ax, 0A000h       ; Base address of video memory
    mov es, ax
    xor di, di           ; Point to the start of video memory

    ; Clear the screen by filling video memory with 0s
    mov cx, 32000        ; Number of iterations needed (320x200/2 bytes)
ClearScreenLoop1:
    mov byte ptr es:[di], 0  ; Write 0 (black) to video memory
    inc di                   ; Move to the next pixel
    loop ClearScreenLoop1     ; Repeat until CX reaches 0
	
	; Return to text mode
    mov ah, 0
    mov al, 2
    int 10h

   ret

Loser ENDP    

;routine that darw line on the screen for each char in the word that in SI register
; we will loop until the end of the word and in each loop we will add a line
drawWlines PROC
        
    ; we will draw the lines under the hello+player name
        ; Print a message that each underline represents a char
       ; Move the cursor 
       mov dh, 3 ;line
       mov dl, 0 ;column
       mov ah, 02h
       int 10h
       mov dx, offset instrgame
       mov ah, 9h
       int 21h
       
       ;move the cursor 
       mov dh,5 ; line 5
       mov dl,20 ; 
       mov ah,02h ; 
       int 10h

      ; mov cx,offset count
	  mov cx,0
      
 
lines_loop:
        mov al,[si] ;load one char to al
        cmp al,'$' ;check if we got to the end of the word
        JE endString  ; jump if equal meaning we got to the end 
        ;now we will draw a line
        ;print

        lea dx,underline
        mov ah,9h
        int 21h
        inc si; move to next char- assume a word is not empty
        inc cx ;inc count
       
        jmp lines_loop ;loop
endString:
       ;print to the player to guess a char
       ;move the cursor 
       mov dh,7 ; line 7
       mov dl,0 ; 
       mov ah,02h ; 
       int 10h
       mov dx,offset guesschar
       mov ah,9h
       int 21h

       mov [count],cx
       ret ; finish 

drawWlines ENDP 
START:
	; Initialize data segment
    mov ax, @data
	mov ds, ax
	
	call designgame ; call a routine that creates a background
   ; call level1 ; start level 1
   call level2
	;only if the user won on level 1:
	mov ax,offset win_sign
	mov ax,[win_sign]
	cmp ax,0
	je EndGame
	
	;call level2 
	call level1


	

	
    ; Return to OS- close the game
EndGame:
    mov ax, 4c00h
	int 21h

;routine that responsible for the start of the game- get the user name and print instructions	
	designgame PROC
        ;text screen because all the game is dealing with strings
        mov ah, 00h
        mov al, 03h
        int 10h
        ;move the cursor to the middle of the line
        mov dh,1 ; line 1
        mov dl,33 ; middle column
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print the question what is the user name
        mov dx,offset quesname
        mov ah, 9h ; print func
        int 21h ;print headline
        ;move the cursor one line down (in order for the typing will not collide with the question line)
        mov dh,2 ; line 2
        mov dl,33 ; middle column
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 

        ; get the name of the user from input and save it in the buffer
        mov ah,0Ah
        mov dx,offset buffer
        int 21h 
        ;delete the question line after the player anwered
        ; print spaces to overwrite the characters
        ;move the cursor one line up - to the question line 
        mov dh,1 ; line 2
        mov dl,33 ; middle column
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        mov cx, 47      ;80-33=47  delete the chars until the end of the line
    clear_loop:
        mov al, ' '
        mov ah, 0Eh     ; 
        int 10h
        loop clear_loop
        ;now we will also clear the print that shows what the player typed
        ; print spaces to overwrite the characters
        ;move the cursor to the typing area
        mov dh,2 ; line 2
        mov dl,33 ; middle column
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        mov cx, 47      ;80-33=47  delete the chars until the end of the line
    clear_loop1:
        mov al, ' '
        mov ah, 0Eh     ; 
        int 10h
        loop clear_loop1
        ;move the cursor to the area I want the print to be at
        mov dh,1 ; line 1
        mov dl,20 ; middle column
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        
        ;print the players name with hello
        lea dx,hellow ;print hello before the name
        mov ah, 09h
        int 21h
        lea dx, buffer + 2  ; skip the length byte and the carriage return
        mov ah, 09h
        int 21h ;print the name

        ;print welcome 
        ;move the cursor to the middle of the line
        mov dh,2 ; line 2
        mov dl,20 ; middle column
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print 
        mov dx,offset welw
        mov ah, 9h ; print func
        int 21h ;print headline
        
 
    
        ;now we will print Instructions 
        ;move the cursor 
        mov dh,3 ; line 3
        mov dl,1 ; 
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print
        mov dx,offset instr1
        mov ah, 9h ; print func
        int 21h ;print headline
        ;move the cursor 
        mov dh,4 ; line 4
        mov dl,1 ; 
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print
        mov dx,offset instr11
        mov ah, 9h ; print func
        int 21h ;print headline
        ;move the cursor 
        mov dh,5 ; line 5
        mov dl,1 ; 
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print
        mov dx,offset instr2
        mov ah, 9h ; print func
        int 21h ;print headline
        ;move the cursor 
        mov dh,6 ; line 6
        mov dl,1 ; 
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print
        mov dx,offset instr21
        mov ah, 9h ; print func
        int 21h ;print headline
        ;move the cursor 
        mov dh,7 ; line 7
        mov dl,1 ; 
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print
        mov dx,offset instr3
        mov ah, 9h ; print func
        int 21h ;print headline
        
        ;ask the player if he is ready to the game
        ;move the cursor 
        mov dh,10 ; line 10
        mov dl,1 ; 
        mov ah,02h ; func so that the print will be in the middle of the screen
        int 10h 
        ; print
        mov dx,offset readyq
        mov ah, 9h ; print func
        int 21h ;print 
        ;wait until the player will press anything
        mov ah,0Ah
        int 21h 

        ;delete all the instructions -clean screen
        mov dl,0
        mov dh,2
        mov ah,02h
        int 10h
        mov cx,9
    clear_lines:

        lea dx,clearRow
        mov ah,9h
        int 21h

        loop clear_lines


        
        ;now the game start! level 1 begins 
        ;call level1 ; start level 1
        ret
        
		

    designgame ENDP
;routine: manage level 1 in the game that is with timer     
   level1 PROC
    mov [win_sign],0 ; the user still didnt win in this round
    ; Right now the screen is blank except for the player name in the first line
    ; Print a message that every underline represents a character
    ; We will draw a line for each character in the word
    ; We will do that by the routine drawWlines and making sure the word we want is in SI
        mov SI, offset guess1
        call drawWlines ; Call the routine to draw the lines
        mov cx, 5 ; Initialize lives to 5

    ; After we draw the underlines we need to let the player guess :)
    loop_guess:
	    ; Get initial tick count
		;save cx, dx
		push cx
		push dx
		mov ah, 0                   ; Function 00h: Read system timer counter
		int 1Ah
		mov word ptr ds:[start_ticks], dx       ; Store initial tick count (low word)
		mov word ptr ds:[start_ticks + 2], cx   ; Store initial tick count (high word)
		;return to orig value
	    pop dx
		pop cx
	    push cx; save cx
		mov cx,0
	    
    ; Wait until the player will press a key nd check if more then 5 seconds have passed
wait_for_key:
        mov ah, 01h                ; Function 01h: Check if a key is pressed
	    int 16h                    ; 

        jz check_time              ; check time if didnt press	
	;	mov ah,08h 
    ;    int 21h ; Now the input char is in AL
    ;    mov ah, 0 ; Reset flag for found character
    ;    mov bx, 0 ; offset to start point of the lines 
	
	 ; f a char was pressed save it in al
    mov ah, 00h        
    int 16h        

        mov dh, 5 ; line 
        mov dl, 20 ; 
        mov ah, 02h ; Set cursor position
        int 10h
		jmp already_guessed
; Get the current tick count
check_time:
            mov [flag_time],0
			push cx
			push dx
			mov ah, 0                   				; Function 00h: Read system timer counter
			int 1Ah
			mov word ptr ds:[end_ticks], dx         	; Store current tick count (low word)
			mov word ptr ds:[end_ticks + 2], cx     	; Store current tick count (high word)
			pop dx
			pop cx   ; ;
			; Calculate elapsed ticks
			mov ax, word ptr ds:[end_ticks]
			sub ax, word ptr ds:[start_ticks]
			mov dx, word ptr ds:[end_ticks + 2]
			sbb dx, word ptr ds: [start_ticks + 2]   	; DX:AX = elapsed ticks, sbb in case lower word underflowed
			
			; Convert elapsed ticks to seconds 
			mov bx, 10                 ; 
			mul bx                      ; DX:AX = elapsed ticks * 10 - for fixed point arithmetic
			mov bx, 182
			div bx						; DX:AX = elapsed ticks / 18.2 (System clock ticks at 18.2 Hz)  
			; Check if 6 seconds have passed
			cmp ax, 6
			jge time_passed		; write that more then 5 seconds have passed
			;pop cx
			jmp wait_for_key
time_passed:
         mov [flag_time],1; time passed flag

        jmp not_in_word		

already_guessed:
    ; Now we want to check if the char is in the word
        mov SI, offset guess1
        MOV DI,OFFSET guess_array

    loop_check:

        inc cx ;move forward another place
    ; The char the user entered is in AL
        mov dl, [si]
        cmp dl, '$' ; End of string
        JE not_in_word
        cmp dl, al
        JE find
        inc si
        inc bx ; one more place
        
        lea dx, underline
        mov ah, 09h
        int 21h
		
      
        
        JMP loop_check
    ;if the char is in the word so draw the char above the lines word
    find:

        ; Print the guessed character
        mov ah, 0Eh
        int 10h
		
        mov [di], al
        INC DI ; move to next slot

        ;PRINT THE Chars that were already guessed
        mov ax, 0b800h
	    mov es, ax
        mov dx,bx;save bx
        mov bx, 1480
        add bx,dx
        add bx,dx  
        add bx,2 

        mov ah, 00011110b 
       


        mov al,[di-1]
        mov es:[bx], al
        inc bx
        mov es:[bx],ah
		
		; cx contain the place in the word the char is found so we will add the char to the help array
		mov SI, offset guess1_help_array
		dec cx
		add SI,cx
		pop cx
		;inc cx; restore true cx
		cmp [si],' '
		je LabelFlag
		mov [si],al
        

 LabelFlag:       ; Flag found
        mov ah, 1
        mov bx,dx ;return to bx

		
		
		
		;check if all letters were guessed
		
		call CheckGuess1
        
        JMP continue_guess
    ;if the char is not in the word or that time has passed without a guess
    not_in_word:
	    ;check if time has passed or guess wrong
		mov ax,[flag_time]
		cmp ax,0
		je guess_wrong
		
		 ;print a message that time passed
	;	 move to page 3 and print
	;	 Switch to text page 3
mov ah, 05h       ; Function 05h: Select display page
mov al, 03h       ; Page number 3
int 10h           ; Call interrupt 10h


; Set the cursor position for printing the string
mov ah, 02h       ; Function 02h: Set cursor position
mov bh, 03h       ; Page number 3 
mov dh, 10        ; Row 
mov dl, 10        ; Column 
int 10h           

; Print "TIME OVER"
lea dx, TIME_OVER       ; Load the address of the string into DX
mov ah, 9h
int 21h
; Wait for a keypress
mov ah, 00h
int 16h   




; Clear text page 3
mov ah, 06h       ; Function 06h: Scroll page up (clears screen if entire page is scrolled)
mov al, 00h       ; Number of lines to scroll (0 = clear entire page)
mov bh, 07h       ; Attribute for blank lines (light gray on black)
mov ch, 00h       ; Upper row = 0 (start of screen)
mov cl, 00h       ; Left column = 0 (start of screen)
mov dh, 19h       ; Lower row = 25-1 (end of screen)
mov dl, 4Fh       ; Right column = 80-1 (end of screen)
int 10h           ; Call interrupt 10h
	
;there was a wrong guess in time	    
guess_wrong:
	    pop cx	
	    DEC cx ;guess wrong 

	
	; Move the cursor 
        mov ah, 02h
        mov dh, 10H ; line 
        mov dl, 0
        int 10h
	


		 
    ; Switch to another page (page 1)
    mov ah, 05h
    mov al, 1        ; Switch to page 1
    int 10h
	


	
	;mov ax,offset countlose ;load count of loses until now
	mov ax,5
	sub ax,cx

    cmp ax, 1         
    je print_hangman1
    cmp ax, 2         
    je print_hangman2
    cmp ax, 3         
    je print_hangman3
    cmp ax, 4        
    je print_hangman4
    cmp ax, 5        
    je print_hangman5 ;meaning you lost!!
	
	
	print_hangman1:
	   lea dx,hangman1
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess
		
	print_hangman2:
	   lea dx,hangman2
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess	
		
	print_hangman3:
	   lea dx,hangman3
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess	
		
	print_hangman4:
	   lea dx,hangman4
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess	
		
		
	print_hangman5:
	   lea dx,hangman5
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        
	   
        
	   call Loser ;loser screen



	
		
        ;JMP continue_guess

    continue_guess:
	

    ; Continue guessing if lives are left
		
        cmp cx, 0
        JG loop_guess
 
        		

End1:   
    ; End of the level1 procedure
        ret

level1 ENDP

;level 2!
;routine: manage level 2 in the game that is without timer 
level2 PROC
    mov [win_sign],0 ; the user still didnt win in this round
	mov [level],2 ; now its level 2
 ; Right now the screen is blank 
    ; Print a message that every underline represents a character
    ; We will draw a line for each character in the word
    ; We will do that by the routine drawWlines and making sure the word we want is in SI
        mov SI, offset guess2
        call drawWlines ; Call the routine to draw the lines
        mov cx, 5 ; Initialize lives to 5
		; After we draw the underlines we need to let the player guess :)
    loop_guess2:
	    push cx; save cx
		mov cx,0
	    
    ; Wait until the player will press a key
		mov ah,08h 
        int 21h ; Now the input char is in AL
        mov ah, 0 ; Reset flag for found character
        mov bx, 0 ; offset to start point of the lines 

        mov dh, 5 ; line 
        mov dl, 20 ; 
        mov ah, 02h ; Set cursor position
        int 10h

    ; Now we want to check if the char is in the word
        mov SI, offset guess2
        MOV DI,OFFSET guess_array2
		
	loop_check2:

        inc cx ;move forward another place
    ; The char the user entered is in AL
        mov dl, [si]
        cmp dl, '$' ; End of string
        JE not_in_word2
        cmp dl, al
        JE find2
        inc si
        inc bx ; one more place
        
        lea dx, underline
        mov ah, 09h
        int 21h
		
      
        
        JMP loop_check2
		
		 ;if the char is in the word so draw the char above the lines word
    find2:

        ; Print the guessed character
        mov ah, 0Eh
        int 10h
		
        mov [di], al
        INC DI ; move to next slot

        ;PRINT THE Chars that were already guessed
        mov ax, 0b800h
	    mov es, ax
        mov dx,bx;save bx
        mov bx, 1480
        add bx,dx
        add bx,dx ; bx=bx+2*dx 
        add bx,2 ; space

        mov ah, 00011110b ; Blue background, yellow foreground
       


        mov al,[di-1]
        mov es:[bx], al
        inc bx
        mov es:[bx],ah
		
		; cx contain the place in the word the char is found so we will add the char to the help array
		mov SI, offset guess2_help_array
		dec cx
		add SI,cx
		pop cx
		cmp [si],' '
		je LabelFlag2
		mov [si],al
        

 LabelFlag2:       ; Flag found
        mov ah, 1
        mov bx,dx ;return to bx

		
		
		
		;check if all letters were guessed
		
		call CheckGuess2
        
        JMP continue_guess2
		
	;if the char is not in the word:	
	not_in_word2:
	    pop cx	
	    DEC cx ;guess wrong 

	
	; Move the cursor 
        mov ah, 02h
        mov dh, 10H ; line 
        mov dl, 0
        int 10h
	

		
		;check page switch
		 
    ; Switch to another page (page 1)
    mov ah, 05h
    mov al, 1        ; Switch to page 1
    int 10h
	


	
	;mov ax,offset countlose ;load count of loses until now
	mov ax,5
	sub ax,cx

    cmp ax, 1         
    je print_hangman12
    cmp ax, 2         
    je print_hangman22
    cmp ax, 3         
    je print_hangman32
    cmp ax, 4        
    je print_hangman42
    cmp ax, 5        
    je print_hangman52 ;meaning you lost!!
	
	
	print_hangman12:
	   lea dx,hangman1
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess2
		
	print_hangman22:
	   lea dx,hangman2
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess2	
		
	print_hangman32:
	   lea dx,hangman3
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess2	
		
	print_hangman42:
	   lea dx,hangman4
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        

       mov ah, 05h  ; back to page zero
       mov al, 0
       int 10h
	
        JMP continue_guess2	
		
		
	print_hangman52:
	   lea dx,hangman5
	   mov ah, 9h
       int 21h
	   ; Wait for a keypress
       mov ah, 00h
       int 16h        
	   ;JMP continue_guess
	   
        
	   call Loser ;lose screen



	
		
        ;JMP continue_guess

    continue_guess2:
	

    ; Continue guessing if lives are left
	    ;pop cx
		
        cmp cx, 0
        JG loop_guess2
 
        		

End2:   
    ; End of the level2 procedure
        ret

ret
   

level2 ENDP
	
end START
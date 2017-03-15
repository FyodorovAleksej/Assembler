.MODEL small                 ;in the main string insert second string 
.STACK 100h                  ;previous input word

.CODE
BEGIN:
mov ax, @data
mov ds, ax
mov es, ax       
xor ax, ax

lea dx, Message1              ;output first message
call OutputString
lea dx,Enter
call OutputString

lea dx, str1b                 ;input main  string
call InputString
lea dx,Enter
call OutputString 

lea dx, Message2              ;output second message
call OutputString
lea dx,Enter
call OutputString

lea dx, str2b                 ;input insert string
call InputString
lea dx,Enter
call OutputString

lea dx, Message3              ;output third message
call OutputString
lea dx,Enter
call OutputString

lea dx, str3b                 ;input word for finding
call InputString
lea dx,Enter
call OutputString

mov al,[str1l]                ;compare length of 2 strings
cmp al,[str3l]
jb exit

xor cx,cx
lea si,str1                   ;work with main string
dec si
jmp start_find


find:        
inc si
cmp [si],' '                  ;find space
je start_find
cmp [si],'$'
je exit      
jmp find
start_find:  
inc si
lea di,str3                   ;compare with third string
call SearchSubstring          ;search third string in the main string
jmp find          
                 
InputString proc              ;for input string
push ax
mov ah,0Ah
int 21h
pop ax                
ret
InputString endp

OutputString proc             ;for putput string
push ax
mov ah,09h
int 21h
pop ax
ret
OutputString endp    



SearchSubstring proc                              
push ax                       ;save all registers
push cx
push di
push si                

mov ax, offset str1           
add al, [str1l]
mov bx, si                    ;the end of string
xor cx,cx
mov cl, [str3l]               ;length of the third string
repe cmpsb                    ;comparing strings di and si
je _EQ
jne _NEQ
_EQ:                           
;mov si,bx
call Shift                    ;shift string
mov di, offset str2           
xor cx,cx
mov cl,[str2l]
xchg si,di
rep movsb                     ;insert second string in main
_NEQ:
pop si
pop di
pop cx 
pop ax
ret
SearchSubstring endp

Shift proc                    ;shift main string
push cx
push di
push bx
 
mov bx,si                     ;save current position
lea ax, str1
add al, [str1l]    
mov si,ax                     ;end of the main string
sub ax,bx                     ;all others elements in the main string
mov cx,ax                     
xor ax,ax
mov al,[str2l]                ;size of shift
inc cx                         
shift_loop:    
 mov bh,[si]                  ;save current element
 add si,ax                    ;shift right
 mov [si],bh                  ;mov saved element
 sub si,ax                    ;shift left
 dec si
loop shift_loop 
xor bh,bh
mov si,bx                     ;load previous position

pop bx
pop di
pop cx
ret
Shift endp


exit:       
lea dx,str1
call OutputString
mov ax,4c00h
int 21h

.DATA
Message1 DB "Enter main string: $"
Message2 DB 0Ah, 0Dh, "Enter insert substring: $"
Message3 DB 0Ah, 0Dh, "Enter word prev insert: $"
Message4 DB 0Ah, 0Dh, "Result string: $"          
Enter    DB 0Ah, 0Dh,  "$"
LENGTH equ 200  

str1b DB '$'
str1l DB LENGTH
str1 DB LENGTH dup('$')

str2b DB '$'
str2l DB LENGTH
str2 DB LENGTH dup('$')

str3b DB '$'
str3l DB LENGTH
str3 DB LENGTH dup('$')

end BEGIN
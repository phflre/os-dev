; print_string:
;     pusha ; Push all register values to the stack
;     mov ah , 0x0e ; int =10/ ah =0 x0e -> BIOS tele - type output
;     .1: 
;     cmp byte [bx], 0
;     je .exit
;     mov al , [bx]
;     int 0x10 ; print the character in al
;     inc bx
;     jmp .1
;     .exit:
;     popa ; Restore original register values
;     ret

print_string:     ; Push registers onto the stack
  pusha

string_loop:
  mov al, [bx]    ; Set al to the value at bx
  cmp al, 0       ; Compare the value in al to 0 (check for null terminator)
  jne print_char  ; If it's not null, print the character at al
                  ; Otherwise the string is done, and the function is ending
  popa            ; Pop all the registers back onto the stack
  ret             ; return execution to where we were

print_char:
  mov ah, 0x0e    ; Linefeed printing
  int 0x10        ; Print character
  add bx, 1       ; Shift bx to the next character
  jmp string_loop ; go back to the beginning of our loop
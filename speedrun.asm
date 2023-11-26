; no license, no warranty, no copyright, no author
; and definitely no liability if you fuck up your piece of shit computer
;
; nasm speedrun.asm
;
; gparted -> create a new partition, any type, set bootable flag
;    dd if=speedrun of=/dev/nvd0p6
;       nvd0p6 is my NVMe drive with ZFS in FreeBSD
;       try sda4 in Linux where sda is your old ass hard drive
;       and partition 4 is after your Windows and Linux paritions, faggot!)
; or use qemu:
;    qemu-system-i386 -fda speedrun
;
org 7C00h
    jmp short Start     ;skip data
Cnt:dw  0x0
Start:
    xor ax, ax          ; clear AH/AL for int16h
    int 16h             ; get a character
    mov bx, ax          ; store  it
    xor ax, ax          ; clear AH/AL for int16h
    mov ax, [Cnt]       ; put counter in AX
    add ax, 2           ; increment by 2 (char + style)
    mov [Cnt],ax        ; store AX in count
    sub ax, 2           ; subtract it again
    mov di, ax          ; use AX as the offset
    mov ax, 0xb800      ; load 0xb8000 as the base address
    mov es, ax          ; put the base address in ES register
    mov cx, 01h         ; repeat once
    mov ah, 07h         ; style = gray on black, oldschool DOS mode
    mov al, bl          ; back up ASCII char in BL register
    rep stosw           ; write to screen
    mov dx, [Buf]       ; get the buffer
    mov ah, al          ; back up the ascii value to BL register
    cmp dx, 0x00        ; if we haven't written this byte
    je High             ; jump to the High byte first
    jmp Low             ; else jump to the low byte first
High:
    cmp ah, 'A'         ; if we're working with a hex letter digit
    jge CharHigh        ; go to the CharHigh code
    sub ah,'0'          ; else subtract '0' because it's a number digit
    jmp DigitHigh       ; jump to the DigitHigh code
CharHigh:
    sub ah,'A'          ; subtract 'A' becuase it's a letter digit
DigitHigh:
    shr ah, 4           ; shift right 4 bits because we're doing high nibble
    mov [Buf], ah       ; move it into the buffer
    inc dx              ; increment our nibble side flag
    jmp Continue        ; jump to the space/enter check
Low:
    cmp ah, 'A'         ; if we're working with a hex letter digit
    jge CharLow         ; jump to the CharLow code
    sub ah, '0'         ; else subtract '0' because it's a number digit
    jmp DigitLow        ; and jump to the digit low code
CharLow:
    sub ah,'0'          ; subtract 'A' because it's a letter digit
DigitLow:
    xor [Buf], ah       ; xor the low nibble wih the high nibble
    mov ah, [Buf]       ; store the value in ah register
    mov di, [Offset]    ; store memory offset in di
    mov [Code+di], ah   ; store nibble in the code area
    inc di              ; increment the offset
    mov [Offset], di    ; put it back in memory
    xor dx, dx          ; clear dx so we can process another nibble
    mov [Buf], dx       ; clear the buffer to loop cleanly
Continue:
    cmp al, 0x20        ; check for space bar
    je short Start      ; if we hit the space bar, back to the start
    cmp al, 0x0d        ; check for the enter key
    jne short Start     ; back to the start if we didn't hit enter
    je Code             ; if we hit the neter key, jump to the code

times 0200h - 2 - ($ - $$)  db 0    ;Zerofill up to 510 bytes

    dw 0AA55h           ; boot sector sig
Buf: db 0x0
Offset: dw 0x00
Code:

; uncomment the line below to create a floppy image, leave commented for MBR boot
times 1474560 - ($ - $$) db 0


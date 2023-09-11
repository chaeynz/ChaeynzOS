; |-----------------------------------------------------------------|    |-----------------------------------------------------------------|
; |              16 Bit X86 General Purpose Registers               |    |                  16 Bit X86 Segment Registers                   |
; |-----------------------------------------------------------------|    |-----------------------------------------------------------------|
; | AX          | BX           | CX             | DX                |    | CS           | DS           | ES             | SS               |
; | Accumulator | Base         | Counter        | Data              |    | Code Segment | Data Segment | Extra Segment  | Stack Segment    |
; |-------------|--------------|----------------|-------------------|    |------------- |--------------|----------------|------------------|
; | SI          | DI           | SP             | BP                |    |              | FS           | GS             |                  |
; | Source      | Destination  | Stack Pointer  | Stack Base Pointer|    |              | GP F Segment | GP G Segment   |                  |
; |-----------------------------------------------------------------|    |-----------------------------------------------------------------|
;
;
; |-----------------------------------------------------------------| 
; |                  16 Bit X86 Pointer Register                    |
; |-----------------------------------------------------------------|
; |                IP               Instruction Pointer             |
; |-----------------------------------------------------------------|
;
;
; |---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
; |                                                                X86 EFLAGS Register                                                                                  |
; |---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
; | CF          | PF           | AF             | ZF        | SF        | TF        | IF                    | DF                | OF            | IOPL                  |
; | Carry Flag  | Parity Flag  | Auxillary Flag | Zero Flag | Sign Flag | Trap Flag | Interrupt enable Flag | Direction Flag    | Overflow Flag | I/O privilege Level   |
; |---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
; |---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
; | IOPL                | NT                | RF            | VM                | AC               | VIF                    | VIP                       | ID            |
; | I/O privilege Level | Nested task flag  | Resume Flag   | Virtual 8086 flag | Aligntment Check | Virtual Interrupt Flag | Virtual Interrupt Pending | ... CPUID ... |
; |---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
;
; dw = define word
; db = define byte

org 0x7C00                  ; OS is booted at 0x7C00
bits 16                     ; tells the nasm Assembler to emit 16 Bit Code

start:
    jmp main

puts:
    push si
    push ax

.loop
    lodsb                   ; loads byte from DS:SI into AL & increments SI
    or al, al               ; performs bitwise OR and stores result in lefthand-side operand (Which is AL here)
                            ; Won't modify AL, but if result is Zero, the ZEROFLAG will be set

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00
    hlt                     ; instruction to halt until next external interrupt is fired
                            ; stops the CPU from doing anything

.halt:
    jmp .halt

times 510-($-$$) db 0       ; pads remaining bytes with zeros ; Legacy Bootloader fills the first sector which is 512 Bytes long
dw 0AA55h                   ; 0x55 0xAA, boot signature which is required for BIOS to recognize the bootloader as valid bootable image
                            ; BIOS looks at the end of the first 512 Byte sector for this signature
                            ; This is why we leave out 2 bytes when padding 


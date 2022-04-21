;notes to linker
.section ".text.boot" ;location in compiled binary

.global _start ;global variable

;first instructions to kernel
_start: ;halting 3 cores for single core OS(FOR NOW)
    mrc p15, #0, r1, c0, c0, #5
    and r1, r1, #3
    cmp r1, #0
    bne halt

;kernel runs from address 0 - 0x8000
mov sp, #0x8000 ;start C stack at location 0x8000

;load address of start and end of BSS
;BSS stores initialized C global variables at compile time
ldr r4, =__bss_start
ldr r9, =__bss_end

;load zero to BSS

mov r5, #0;load 0 to four registers
mov r6, #0
mov r7, #0
mov r8, #0
b       2f 


1:;if true 
    stmia r4!, {r5-r8} 

2:;check address in r4 < address in r9
    cmp r4, r9
    blo 1b

    ldr r3, =kernel_main ;load address of kernel main
    blx r3 ;jump to location

halt: ;loops forever when kernel main returns
    wfe
    b halt
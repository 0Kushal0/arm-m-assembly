.equ SYST_CSR, 0xE000E010
.equ SYST_RVR, 0xE000E014
.equ SYST_CVR, 0xE000E018
.equ SYST_CALIB, 0xE000E01C
.equ timeout, 0x0FFFFFFF


.section .vectors
vector_table :
    .word 0x20001000
    .word resethandler
    .org 0x3c
    .word systickhandler
    .zero 20

    .section .text
    .align 1
    .type resethandler, %function
resethandler:
    ldr r0, =SYST_RVR
    ldr r1, =timeout
    str r1, [r0]

    ldr r0, =SYST_CSR
    mov r1, #7
    str r1, [r0]

    b .

    .section .text
    .align 1
    .type systickhandler, %function
systickhandler:
    push {r4 - r7}

    mov r0, r8
    mov r1, r9
    mov r2, r10
    mov r3, r11

    push {r0-r3}

success:
    ldr r0, =stackaddress + 12
    ldr r1, [r0]
    ldr r2, =stackaddress + 16
    ldr r3, [r2]

    mov r4, #4

    add r3, r3, #1
    str r3, [r2]

    mov sp, r1
    ldr r1, =stackaddress
    mul r4, r4, r3
    add r1, r1, r4
    ldr r1, [r1]
    str r1, [r0]

    cmp r3, #3
    beq resetnextstack
    b magic

resetnextstack:
    ldr r1, =stackaddress
    ldr r1, [r1]
    str r1, [r0]

    mov r3, #1
    str r3, [r2]

magic:
    pop {r0-r3}

    mov r8, r0
    mov r9, r1
    mov r10, r2
    mov r11, r3

    pop {r4-r7}

    bx lr


    .section .data
    .align 4
stack1:
    .word 0x18
    .word 0x19
    .word 0x1a
    .word 0x1b
    .word 0x14
    .word 0x15
    .word 0x16
    .word 0x17
    .word 0x10
    .word 0x11
    .word 0x12
    .word 0x13
    .word 0x1c
    .word 0x309
    .word main1
    .word 0x01000000
    .zero 100

    .section .data
    .align 4
stack2:
    .word 0x28
    .word 0x29
    .word 0x2a
    .word 0x2b
    .word 0x24
    .word 0x25
    .word 0x26
    .word 0x27
    .word 0x20
    .word 0x21
    .word 0x22
    .word 0x23
    .word 0x2c
    .word 0x309
    .word main2
    .word 0x01000000
    .zero 100

    .section .data
    .align 4
stack3:
    .word 0x38
    .word 0x39
    .word 0x3a
    .word 0x3b
    .word 0x34
    .word 0x35
    .word 0x36
    .word 0x37
    .word 0x30
    .word 0x31
    .word 0x32
    .word 0x33
    .word 0x3c
    .word 0x309
    .word main3
    .word 0x01000000
    .zero 100

    .section .data
stackaddress:
    .word stack1
    .word stack2
    .word stack3
    .word stack1
    .word 0

    .section .text
    .p2align 4
    .globl main1
    .type main1, %function
main1 :
    add r0, r0, #1
    b main1

    .section .text
    .p2align 4
    .globl main2
    .type main2, %function
main2 :
    add r1, r1, #1
    b main2

    .section .text
    .p2align 4
    .globl main3
    .type main3, %function
main3 :
    add r0, r0, #1
    b main3

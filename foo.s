/*
 * Cteate a vector table, which contains sp, resethandler & systickhandler.
 * Create a resethandler, which will config the systickhandler.
 * Create a systickhandler, which will saves the cpu context in stack.
 * Before pop operation set the sp to the stack memory for which task u want to run.
 * Creata a stackaddress which holds all the stackaddress, next stackaddress & index.
 * Get the next stackaddress and index in gpr.
 * set the sp with with stackaddress and change the next stackaddress and increment index.
 * if index reaches 3, set the mext stackaddress to first task stack memory.
*/

.equ  SYST_CSR, 0xE000E010
.equ  SYST_RVR, 0xE000E014
.equ  SYST_CVR, 0xE000E018
.equ  SYST_CALIB, 0xE000E01C
.equ  timeout, 0x0fffffff

.section .vectors
vectortable :
    .word 0x20001000      // Initial SP value
    .word resethandler  // Reset Handler (Thumb bit set)
.org 0x3c
    .word systickhandler // SysTick Handler (Thumb bit set)
    .zero 100

    .section .text
    .align 1
    .type resethandler, %function
resethandler :
    ldr r0, =SYST_RVR
    ldr r1, =timeout
    str r1, [r0]

    ldr r0, =SYST_CVR
    mov r1, #0
    str r1, [r0]

    ldr r0, =SYST_CSR
    mov r1, #7
    str r1, [r0]

    b .



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
    .word Task1
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
    .word Task2
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
    .word Task3
    .word 0x01000000
    .zero 100

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

.section .stackaddress
stackaddress:
    .word 0x20000000
    .word 0x200000b0
    .word 0x20000160
    .word 0x20000000
    .word 0x0

    .section .text
    .align 1
    .type systickhandler, %function
systickhandler :
    push {r4-r7}

    ldr r4, =stackaddress
    add r4, r4, #12
    ldr r5, =stackaddress
    add r5, r5, #16

    mov r0, r8
    mov r1, r9
    mov r2, r10
    mov r3, r11

    push {r0-r3}

magic :

    ldr r0, [r4]
    mov sp, r0

    ldr r2, [r5]
    add r2, r2, #1
    str r2, [r5]

    mov r0, #4
    ldr r1, =stackaddress
    mul r0, r0, r2
    add r1, r1, r0
    ldr r1, [r1]
    str r1, [r4]

    //reset to first task
    cmp r2, #3
    beq reset_task
    b continue_task

reset_task:
    ldr r3, =stackaddress
    ldr r3, [r3]
    str r3, [r4]

    mov r2, #0
    str r2, [r5]

continue_task:
    pop {r0-r3}

    mov r8, r0
    mov r9, r1
    mov r10, r2
    mov r11, r3

    pop {r4-r7}

    bx lr

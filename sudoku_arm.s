.section .text
.global _start

_start:
    bl   main
    // mov  r0, #0
    b    exit


main:
    push    {fp, lr}
    mov     fp, sp
    sub     sp, sp, #16

    mov     r0, #0x00
    mov     r1, #0x00
    bl      solve

    end_main:
    mov     sp, fp
    pop     {fp, pc}


solve:
    // r0 - pos_i, r1 - pos_j
    push    {fp, lr}
    mov     fp, sp
    sub     sp, sp, #0x20

    // print and exit if i is 9
    cmp     r0, #0x09
    moveq   r0, #0x00
    bleq    hello
    beq     exit

    // set `r8` if digit on current position is not `0x30`
    ldr     r4, =sudoku
    mov     r5, #0x09
    mul     r6, r5, r0
    add     r6, r6, r1
    mov     r8, #0x00
    ldrb    r3, [r4, r6]
    cmp     r3, #0x30
    movne   r8, #0x01

    // go to the next position if `r8` is set
    push    {r0, r1}
    add     r1, r1, #0x01
    mov     r3, r1
    sub     r3, r3, #0x09
    cmp     r3, #0x00
    movge   r1, r3
    addge   r0, r0, #0x01
    cmp     r8, #0x00
    blne    solve
    pop     {r0, r1}
    bne     end_solve

    mov     r2, #0x31
    loop_solve:
    push    {r0, r1}
    bl      validate
    cmp     r0, #0x00
    pop     {r0, r1}
    bne     k_next
    // store current k
    ldr     r4, =sudoku
    mov     r5, #0x09
    mul     r6, r0, r5
    add     r6, r6, r1
    strb    r2, [r4, r6]
    // call next iteration
    push    {r0, r1, r2}
    add     r1, r1, #0x01
    mov     r3, r1
    sub     r3, r3, #0x09
    cmp     r3, #0x00
    movge   r1, r3
    addge   r0, r0, #0x01
    bl      solve
    pop     {r0, r1, r2}
    
    k_next:
    add     r2, r2, #0x01
    cmp     r2, #0x3a
    blt     loop_solve

    // reset cell if got here
    ldr     r4, =sudoku
    mov     r5, #0x09
    mul     r6, r0, r5
    add     r6, r6, r1
    mov     r8, #0x30
    strb    r8, [r4, r6]

    end_solve:
    mov     sp, fp
    pop     {fp, pc}


validate:
    // r0 -> i
    // r1 -> j
    // r2 -> k - the number that we try
    push    {fp}
    mov     fp, sp
    sub     sp, sp, #12

    mov     r3, #0x00
    push    {r1}

    ldr     r4, =sudoku
    mov     r5, #0x00
    mov     r8, #0x09
    mul     r6, r0, r8
    _loop_validate_i:
    ldrb    r8, [r4, r6]
    cmp     r2, r8
    moveq   r3, #0x01
    beq     end_validate
    add     r6, r6, #0x01
    add     r5, r5, #1
    cmp     r5, #0x09
    blt     _loop_validate_i

    mov     r5, r1
    _loop_validate_j:
    ldrb    r8, [r4, r5]
    cmp     r2, r8
    moveq   r3, #0x01
    beq     end_validate
    add     r5, r5, #0x09
    cmp     r5, #0x51
    ble     _loop_validate_j

    // unroll division since there is only 3 steps / index
    i_index:
    mov     r5, #0x00
    sub     r0, r0, #3
    cmp     r0, #0x00
    addge   r5, r5, #0x03
    sub     r0, r0, #3
    cmp     r0, #0x00
    blt     j_index
    add     r5, r5, #0x03

    j_index:
    mov     r6, #0x00
    sub     r1, r1, #0x03
    cmp     r1, #0x00
    addge   r6, r6, #0x03
    sub     r1, r1, #0x03
    cmp     r1, #0x00
    blt     block_check
    add     r6, r6, #0x03

    block_check:
    mov     r0, r5
    mov     r1, r6
    mov     r8, #0x09
    mul     r5, r0, r8
    add     r5, r5, r1
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x01
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x01
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x07
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x01
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x01
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x07
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x01
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01
    add     r5, r5, #0x01
    ldrb    r6, [r4, r5]
    cmp     r6, r2
    moveq   r3, #0x01

    end_validate:
    pop     {r1}
    mov     r0, r3 // return in r0
    mov     sp, fp
    pop     {fp}
    bx      lr

hello:
    push {fp}
    mov  fp, sp
    sub     sp, sp, #12
    // say hello
    mov     r5, #0x00
    loop_hello:
    mov     r7, #0x04
    mov     r0, #1
    ldr     r1, =sudoku
    add     r1, r1, r5
    mov     r2, #0x09
    swi     0
    mov     r7, #0x04
    mov     r0, #1
    ldr     r1, =nline
    mov     r2, #1
    swi     0
    add     r5, r5, #0x09
    cmp     r5, #0x51
    blt     loop_hello

    mov     sp, fp
    pop     {fp}
    bx      lr

exit:
    mov     r7, #1
    swi     0

.section .data
nline:
    .asciz "\n"
sudoku:
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30
    .byte 0x30

.section .data
.cpu mpcore
.arm

.equ BRIGHTNESS, 0xBF @ ~75%

@ Only sets brightness, framebuffer locations, format and stride
@ Also changes the MPCore entrypoint to 0x1FFFFFFC for compatibility
@ with newer software
.global mpcorebin_start
mpcorebin_start:
    cpsid aif, #0x13

    mov r0, #0
    mcr p15, 0, r0, c7, c7, 0
    mcr p15, 0, r0, c7, c14, 0
    mcr p15, 0, r0, c7, c10, 4

    ldr r0, =0x00054078
    ldr r1, =0x0000000F
    ldr r2, =0x00000000

    mcr p15, 0, r0, c1, c0, 0
    mcr p15, 0, r1, c1, c0, 1
    mcr p15, 0, r2, c1, c0, 2

    @ MMU and caches are off

    ldr r0, =0x10202000
    ldr r1, =BRIGHTNESS
    str r1, [r0, #0x240]
    str r1, [r0, #0xA40]

    ldr r0, =0x10400000
    ldr r1, =0x18300000
    ldr r2, =0x18346500
    ldr r3, =0x00000000
    ldr r4, =0x00080341
    bic r5, r4, #0x40
    ldr r6, =0x000002D0

    @ Setup GPU registers
    str r1, [r0, #0x468]
    str r1, [r0, #0x46C]
    str r1, [r0, #0x494]
    str r1, [r0, #0x498]
    str r2, [r0, #0x568]
    str r2, [r0, #0x56C]

    str r4, [r0, #0x470]
    str r5, [r0, #0x570]
    str r6, [r0, #0x490]
    str r6, [r0, #0x590]
    str r3, [r0, #0x478]
    str r3, [r0, #0x578]

    @ Setup framebuffers
    ldr r3, =0x23FFFE00
    mov r0, r1
    stmia r3!, {r0-r2}
    stmia r3!, {r0-r2}

    @ Notify the ARM9
    mov r0, #0x20000000
    mov r1, #0
    str r1, [r0, #-4]

    @ Keep checking for a new entrypoint
    .Lcheckmpcentry:
        ldr r1, [r0, #-4]
        cmp r1, #0
        beq .Lcheckmpcentry

    bx r1
.pool
mpcorebin_end:

.global mpcorebin_len
mpcorebin_len: .word (mpcorebin_end - mpcorebin_start)

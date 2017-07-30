.section .text.start
.align 4
.arm

.equ MPCORE_ENTRY, 0x1FFFF300

.global _start
_start:
    .rept 12
    nop
    .endr

    msr cpsr_c, #0xD3

    @ Small delay
    mov r0, #0x40000
    .Lwaitloop:
        subs r0, #1
        bgt .Lwaitloop

    adr r0, _start
    ldr r1, =__start__
    cmp r0, r1
    beq _start_oloader

    @ Relocate binary if needed
    ldr r2, =__code_size__
    .Lbincopyloop:
        subs r2, #4
        ldrge r3, [r0, r2]
        strge r3, [r1, r2]
        bge .Lbincopyloop

    mov r4, r1

    @ Writeback DCache
    ldr r0, =0xFFFF07FC       
    blx r0

    @ Invalidate ICache
    mov lr, #0
    mcr p15, 0, lr, c7, c5, 0

    bx r4

_start_oloader:
    ldr sp, =__stack_top

    @ Writeback and Invalidate DCache
    ldr r0, =0xFFFF0830
    blx r0

    @ Disable mpu/caches/dtcm
    ldr r1, =((1<<0)|(1<<2)|(1<<12)|(1<<16))
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r1
    mcr p15, 0, r0, c1, c0, 0

    @ Invalidate caches
    mov r0, #0
    mcr p15, 0, r0, c7, c5, 0
    mcr p15, 0, r0, c7, c6, 0
    mcr p15, 0, r0, c7, c10, 4

    @ Clear bss
    ldr r0, =__bss_start
    mov r1, #0
    ldr r2, =__bss_end
    sub r2, r0
    blx memset

    @ Setup region access permissions
    ldr r0, =0x33333333
    mcr p15, 0, r0, c5, c0, 2 @ write data access
    mcr p15, 0, r0, c5, c0, 3 @ write instruction access

    @ Setup mpu regions
    ldr r0, =0xFFFF001F @ ffff0000 64k  | bootrom (unprotected / protected)
    ldr r1, =0xFFF0001B @ fff00000 16k  | dtcm
    ldr r2, =0x01FF801D @ 01ff8000 32k  | itcm
    ldr r3, =0x08000029 @ 08000000 2M   | arm9 mem (O3DS / N3DS)
    ldr r4, =0x10000029 @ 10000000 2M   | io mem (ARM9 / first 2MB)
    ldr r5, =0x20000037 @ 20000000 256M | fcram (O3DS / N3DS)
    ldr r6, =0x1FF00027 @ 1FF00000 1M   | dsp / axi wram
    ldr r7, =0x1800002D @ 18000000 8M   | vram (+ 2MB)
    mov r8, #0b00101101 @ bootrom/itcm/arm9 mem and fcram are cacheable/bufferable
    mcr p15, 0, r0, c6, c0, 0
    mcr p15, 0, r1, c6, c1, 0
    mcr p15, 0, r2, c6, c2, 0
    mcr p15, 0, r3, c6, c3, 0
    mcr p15, 0, r4, c6, c4, 0
    mcr p15, 0, r5, c6, c5, 0
    mcr p15, 0, r6, c6, c6, 0
    mcr p15, 0, r7, c6, c7, 0
    mcr p15, 0, r8, c3, c0, 0   @ Write bufferable 0, 2, 5
    mcr p15, 0, r8, c2, c0, 0   @ Data cacheable 0, 2, 5
    mcr p15, 0, r8, c2, c0, 1   @ Inst cacheable 0, 2, 5

    @ Setup dtcm register
    ldr r0, =0xFFF0000A
    mcr p15, 0, r0, c9, c1, 0

    @ Relocate MPCore binary
    ldr r0, =MPCORE_ENTRY
    ldr r1, =mpcorebin_start
    ldr r2, =mpcorebin_len
    ldr r2, [r2]
    blx memcpy

    @ Set the MPCore entrypoint
    mov r0, #0x20000000
    ldr r1, =MPCORE_ENTRY
    str r1, [r0, #-4]
    str r1, [r0, #-8]

    @ Wait until MPCore is done
    mov r0, #0x20000000
    .Lwaitmpc:
        ldr r1, [r0, #-4]
        cmp r1, #0
        bne .Lwaitmpc

    @ Enable mpu/caches/dtcm/itcm
    ldr r1, =((1<<0)|(1<<2)|(1<<12)|(1<<16)|(1<<18))
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r1
    mcr p15, 0, r0, c1, c0, 0

    @ Unknown register (fixes SDMC?)
    ldr r0, =0x10000000
    mov r1, #0x340
    str r1, [r0, #0x20]

    b main

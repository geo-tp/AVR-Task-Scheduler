.section .bss
.global ms_flag
ms_flag:
    .byte 0

.section .text
.global start_scheduler
.global __vector_11  ; Timer1 Compare Match A

; ========================================
; Start the scheduler using Timer1 (1ms tick)
; ========================================
start_scheduler:
    ; CTC mode (WGM12 = 1)
    ldi r16, 0x08
    sts 0x80, r16       ; TCCR1B

    ; Set OCR1A = 250 (0x00FA) => 1ms @ 16MHz / 64
    ldi r16, 0xFA
    sts 0x88, r16       ; OCR1AL
    ldi r16, 0x00
    sts 0x89, r16       ; OCR1AH

    ; Enable Compare Match A interrupt
    ldi r16, 0x02
    sts 0x6F, r16       ; TIMSK1

    ; Start timer with clk/64 prescaler (CS11 | CS10)
    ldi r16, 0x0B
    sts 0x81, r16       ; TCCR1B

    sei                 ; Enable global interrupts

.Lmain_loop:
    ; Wait for 1ms tick
    lds r16, ms_flag
    tst r16
    breq .Lmain_loop

    ; Reset ms_flag
    ldi r16, 0
    sts ms_flag, r16

    ; idx = 0
    ldi r17, 0

.Ltask_loop:
    lds r20, task_count
    cp r17, r20
    brsh .Lmain_loop

    ; addr = task_table + idx * 6
    ldi r18, 6
    mul r17, r18
    ldi r30, lo8(task_table)
    ldi r31, hi8(task_table)
    add r30, r0
    adc r31, r1
    clr r1

    ; --- Read current ---
    adiw r30, 4          ; current offset
    ld r21, Z            ; current low
    adiw r30, 1
    ld r22, Z            ; current high
    sbiw r30, 5          ; restore base addr

    ; --- Decrement current (16-bit) ---
    subi r21, 1
    sbci r22, 0

    ; --- Write back current ---
    adiw r30, 4
    st Z, r21
    adiw r30, 1
    st Z, r22
    sbiw r30, 5

    ; --- If current != 0, skip task ---
    or r21, r22
    brne .Lskip

    ; --- Reload current = interval ---
    adiw r30, 2          ; interval offset
    ld r21, Z            ; interval low
    adiw r30, 1
    ld r22, Z            ; interval high
    sbiw r30, 3          ; back to base

    adiw r30, 4          ; write to current
    st Z, r21
    adiw r30, 1
    st Z, r22
    sbiw r30, 5

    ; --- Call loop function ---
    ld r18, Z
    adiw r30, 1
    ld r19, Z
    sbiw r30, 1
    mov r30, r18
    mov r31, r19
    icall

.Lskip:
    inc r17
    rjmp .Ltask_loop

; ========================================
; ISR: Timer1 Compare Match A (1ms tick)
; ========================================
__vector_11:
    ldi r16, 1
    sts ms_flag, r16
    reti

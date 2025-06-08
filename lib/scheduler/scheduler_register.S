.section .bss
.global task_table
.global task_count

.set MAX_TASKS, 16
.set TASK_SIZE, 6
.set TASK_TABLE_SIZE, MAX_TASKS * TASK_SIZE

task_table:
    .skip TASK_TABLE_SIZE

task_count:
    .byte 0

.section .text
.global register_task
register_task:
    ; Input :
    ;   r24:r25 = fonction (loop ptr)
    ;   r22:r23 = interval

    ; Read task_count
    lds r20, task_count
    ldi r21, MAX_TASKS
    cp r20, r21
    brsh .Lexit              ; taskcount > MAX_TASKS, exit

    ; Calculate address task_table : base + index * TASK_SIZE
    ldi r21, TASK_SIZE
    mul r20, r21
    ldi r30, lo8(task_table)
    ldi r31, hi8(task_table)
    add r30, r0
    adc r31, r1
    clr r1                   ; clear high byte

    ; loop ptr (2 octets)
    st Z+, r24
    st Z+, r25

    ; interval (2 octets)
    st Z+, r22              ; low
    st Z+, r23              ; high

    ; current = interval (2 octets)
    st Z+, r22              ; low
    st Z+, r23              ; high

    ; increment counter
    inc r20
    sts task_count, r20

.Lexit:
    ret

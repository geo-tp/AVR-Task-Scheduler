#ifndef SCHEDULER_H
#define SCHEDULER_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define MAX_TASKS 16

typedef struct {
    void (*loop)(void);
    uint16_t interval;
    uint16_t current;
} Task;

extern Task task_table[MAX_TASKS];
extern uint8_t task_count;

void register_task(void (*loop)(void), uint16_t interval);
void start_scheduler(void);

#ifdef __cplusplus
}
#endif

#endif // SCHEDULER_H

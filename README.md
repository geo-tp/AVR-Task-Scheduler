# AVR Task Scheduler (Assembly + Arduino)

This project implements a lightweight, cooperative task scheduler written in **AVR assembly** for **Arduino Uno**.

## Features

- Written in pure AVR assembly.
- Supports up to 16 concurrent tasks.

## Requirements

- Board: Arduino Uno (ATmega328P)

## Example

```cpp
#include <Arduino.h>
#include "scheduler.h"

void toggle_led() {
    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
}

void ring_buzzer() {
    digitalWrite(2, !digitalRead(2));
}

void print_serial() {
    Serial.println("Hello from scheduler!");
}

void setup() {
    Serial.begin(9600);
    pinMode(LED_BUILTIN, OUTPUT);
    pinMode(2, OUTPUT);

    register_task(toggle_led, 1000);     // LED every 1s
    register_task(ring_buzzer, 300);     // Buzzer every 300ms
    register_task(print_serial, 2000);   // Serial print every 2s

    start_scheduler(); // Never returns
}

void loop() {
    // Unused, needed for Arduino environment
}
```

## File Structure

```
├── lib/
│   └── scheduler/
│       ├── scheduler_loop.S
│       ├── scheduler_register.S
│       └── scheduler.h
├── src/
│   └── main.cpp
├── platformio.ini
└── README.md
```
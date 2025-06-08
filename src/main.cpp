#include <Arduino.h>
#include "scheduler.h"

// Blink LED Builtin Arduino Uno (pin 13 = PB5)
void toggle_led() {
    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
}

// Toggle Buzzer on pin 2 (PD2)
void toggle_buzzer() {
    digitalWrite(2, !digitalRead(2));
}

// Print a serial message
void print_serial() {
    Serial.println("Hello from scheduler");
}

void setup() {
    Serial.begin(9600);

    pinMode(LED_BUILTIN, OUTPUT);
    pinMode(2, OUTPUT);

    // Register tasks
    register_task(toggle_led, 1000);      // Toggle LED every 1s
    register_task(toggle_buzzer, 300);    // Toggle buzzer every 300ms
    register_task(print_serial, 2000);    // Print message every 2s

    // Start the scheduler (infinite loop)
    start_scheduler();
}

void loop() {
    // Unused but required by Arduino
}
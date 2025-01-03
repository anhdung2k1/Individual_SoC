#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "io.h"
#include "system.h"

// Function selectors
#define FUNC_ADDER       0x0
#define FUNC_ADDER_P2    0x1
#define FUNC_MULTIPLIER  0x2
#define FUNC_MULTIPLIER_M2 0x3
#define FUNC_PRIME_GEN   0x4

// Internal registers
uint32_t p1 = 0, p2 = 0;           // Adder registers
uint32_t m1 = 0, m2 = 0;           // Multiplier registers
uint32_t primes[256] = {0};        // Array for prime numbers
uint32_t max = 0;                  // Maximum number for prime generation
uint32_t oData = 0;                // Output data

// Function prototypes
void handle_write(uint8_t address, uint32_t data);
uint32_t handle_read(uint8_t address, uint32_t index);
void generate_primes(uint32_t max);
bool is_prime(uint32_t number);
void write_to_hex_decoders_1(uint32_t value);
void write_to_hex_decoders_2(uint32_t value);

int main() {
    printf("========== Starting Prime Number Generator ===========\n");

    while (1) {
        // Read switch values
        uint32_t switches = IORD(SWITCHES_0_BASE, 0);

        // Generate primes based on SW[7:0]
        uint32_t start_prime = (switches & 0xFF);
        handle_write(FUNC_PRIME_GEN, start_prime + 255);

        // Use SW9 to control multiplier
        if (switches & 0x200) { // SW9 enabled
            uint32_t multiplier_input1 = handle_read(FUNC_PRIME_GEN, (switches & 0xF0) >> 4); // Use upper nibble of SW[7:0]
            uint32_t multiplier_input2 = handle_read(FUNC_PRIME_GEN, switches & 0xF); // Use lower nibble of SW[7:0]
            handle_write(FUNC_MULTIPLIER, multiplier_input1); // Write to m1
            handle_write(FUNC_MULTIPLIER_M2, multiplier_input2); // Write to m2
            uint32_t multiplier_result = handle_read(FUNC_MULTIPLIER, 0);
            printf("Multiplier result: %u * %u = %u\n", (unsigned int)multiplier_input1, (unsigned int)multiplier_input2, (unsigned int)multiplier_result);
            write_to_hex_decoders_2(multiplier_result); // Display result on HEX2 and HEX3
        } else {
            // Clear HEX2 and HEX3 when SW9 is off
            IOWR(HEXDECODER_2_BASE, 0, 0);
            IOWR(HEXDECODER_3_BASE, 0, 0);
        }

        // Use SW8 to control adder
        if (switches & 0x100) { // SW8 enabled
            uint32_t adder_input1 = handle_read(FUNC_PRIME_GEN, (switches & 0xF0) >> 4); // Use upper nibble of SW[7:0]
            uint32_t adder_input2 = handle_read(FUNC_PRIME_GEN, switches & 0xF); // Use lower nibble of SW[7:0]
            handle_write(FUNC_ADDER, adder_input1); // Write to p1
            handle_write(FUNC_ADDER_P2, adder_input2); // Write to p2
            uint32_t adder_result = handle_read(FUNC_ADDER, 0);
            printf("Adder result: %u + %u = %u\n", (unsigned int)adder_input1, (unsigned int)adder_input2, (unsigned int)adder_result);
            write_to_hex_decoders_1(adder_result); // Display result on HEX0 and HEX1
        } else {
            // Clear HEX0 and HEX1 when SW8 is off
            IOWR(HEXDECODER_0_BASE, 0, 0);
            IOWR(HEXDECODER_1_BASE, 0, 0);
        }
    }

    return 0;
}

void handle_write(uint8_t address, uint32_t data) {
    switch (address) {
        case FUNC_ADDER:
            p1 = data;
            break;
        case FUNC_ADDER_P2:
            p2 = data;
            break;
        case FUNC_MULTIPLIER:
            m1 = data;
            break;
        case FUNC_MULTIPLIER_M2:
            m2 = data;
            break;
        case FUNC_PRIME_GEN:
            max = data;
            generate_primes(max);
            break;
        default:
            printf("Invalid write address\n");
    }
}

uint32_t handle_read(uint8_t address, uint32_t index) {
    switch (address) {
        case FUNC_ADDER:
            oData = p1 + p2;
            break;
        case FUNC_MULTIPLIER:
            oData = m1 * m2;
            break;
        case FUNC_PRIME_GEN:
            if (index < 256) {
                oData = primes[index];
            } else {
                oData = 0; // Return 0 for out-of-bound indices
            }
            break;
        default:
            printf("Invalid read address\n");
            oData = 0;
    }
    return oData;
}

void generate_primes(uint32_t max) {
    memset(primes, 0, sizeof(primes));
    uint32_t count = 0;
    for (uint32_t i = 2; i <= max && count < 256; i++) {
        if (is_prime(i)) {
            primes[count++] = i;
        }
    }
}

bool is_prime(uint32_t number) {
    if (number < 2) return false;
    for (uint32_t i = 2; i * i <= number; i++) {
        if (number % i == 0) return false;
    }
    return true;
}

void write_to_hex_decoders_1(uint32_t value) {
    uint8_t digit_1 = (value / 10) % 10;
    uint8_t digit_0 = value % 10;

    IOWR(HEXDECODER_0_BASE, 0, digit_0);
    IOWR(HEXDECODER_1_BASE, 0, digit_1);
}

void write_to_hex_decoders_2(uint32_t value) {
	uint8_t digit_3 = (value / 10) % 10;
    uint8_t digit_2 = value % 10;

    IOWR(HEXDECODER_2_BASE, 0, digit_2);
    IOWR(HEXDECODER_3_BASE, 0, digit_3);
}

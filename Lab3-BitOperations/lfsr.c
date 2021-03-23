#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"
#include "bit_ops.c"
void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    // uint16_t start_state = 1;
    // do
    // {
    //     *reg ^= *reg >> 7;
    //     *reg ^= *reg << 9;
    //     *reg ^= *reg >> 13;
    //     // ++period;
    // }
    // while (*reg != start_state);
    // unsigned alpha = (((get_bit(*reg, 0)^get_bit(*reg, 2))^get_bit(*reg,3))^get_bit(*reg, 5));
    unsigned n = (((get_bit(*reg, 0) ^ get_bit(*reg, 2))^get_bit(*reg, 3))^get_bit(*reg, 5));
    for (uint8_t charlie = 0; charlie < 15; charlie++){
        set_bit((unsigned int *) reg, charlie, get_bit(*reg, charlie + 1));
        set_bit((unsigned int *) reg, 15, n);
    }
}


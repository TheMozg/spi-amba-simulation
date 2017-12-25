#ifndef __MIPS_PRINTF_H
#define __MIPS_PRINTF_H

#include <stdio.h>
#include "mfp_memory_mapped_registers.h"

#define UART_DIVIDER_9600    5208
#define UART_DIVIDER_115200  434

void uart_set_divider(int divider);
void uart_outchar(char c);
void uart_outstring(char *str);

extern char __strbuf[256];

#define mips_printf(fmt, ...) do { sprintf(__strbuf, fmt, ##__VA_ARGS__); uart_outstring(__strbuf); } while (0)
    
#endif // __MIPS_PRINTF_H

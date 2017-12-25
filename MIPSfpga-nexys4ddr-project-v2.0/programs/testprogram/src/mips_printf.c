#include "mips_printf.h"

char __strbuf[256];

void uart_set_divider(int divider)
{
    UART_TX_DVDR = divider;
}

void uart_outchar(char c)
{
    int status;
    
    while ((status = UART_TX_CTRL) & 0x1); // wait for end of transmit
    
    UART_TX_DATA = c;
}

void uart_outstring(char *str)
{
    int status;
    
    while (*str)
    {
        uart_outchar(*str++);
    }
}

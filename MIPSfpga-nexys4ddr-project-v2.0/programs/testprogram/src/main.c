#include "mfp_memory_mapped_registers.h"
#include "mips_printf.h"

void delay();

int main ()
{
    unsigned long n = 0;
    unsigned long buttons, buttons_prev;
    unsigned long switches, switches_prev;

    for (;;)
    {
        n++;
        
        // Output new value
        
        MFP_7_SEGMENT_HEX = n;
        
        // Process buttons
        
        buttons = MFP_BUTTONS;
        if ( buttons != buttons_prev )
        {
            mips_printf("Button state changed! New state: 0x%02X\r\n", buttons);
            buttons_prev = buttons;
        }
        
        // Process switches
        
        switches = MFP_SWITCHES;
        if ( switches != switches_prev )
        {
            mips_printf("Switches state changed! New state: 0x%04X\r\n", switches);
            MFP_GREEN_LEDS = switches;
            switches_prev = switches;
        }
        
        // Delay every 0x100000 iteration
        
        if ( ! ( n & 0x000FFFFF ) )
        {
            mips_printf("counter = %010d (0x%08X)\r\n", n, n);
            delay();
        }
    }

    return 0;
}

void delay()
{
  volatile unsigned int j;

  for (j = 0; j < 2000000; j++);	// delay 
}

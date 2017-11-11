#include "systemc.h"

// Clock generator, receives F, generates F/4
SC_MODULE( clock_gen ) {

  sc_in_clk     clock;
  sc_out<bool>  qclk; // Quarter of the clock
  sc_in<bool>   enable;
  sc_uint<2>    divider;

  void tick( );

  SC_CTOR( clock_gen ): 
    qclk( "QCLOCK" ) {
    divider = 0;
    SC_METHOD( tick );
    sensitive << clock.pos();
  }
};


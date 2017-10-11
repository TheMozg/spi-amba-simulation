#include "systemc.h"

// Clock generator, receives F, generates F/4
SC_MODULE( clock_gen ) {

  sc_in_clk     clock;
  sc_out<bool>  qclk; // Quarter of the clock

  // Half of the clock
  bool hclk;

  void tick( );

  SC_CTOR( clock_gen ): 
    qclk( "QCLOCK" ) {
    SC_METHOD( tick );
    sensitive << clock.pos();
  }
};


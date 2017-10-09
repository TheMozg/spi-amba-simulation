#include "systemc.h"

// Clock generator, receives F, generates F/2, F/4
SC_MODULE( clock_gen ) {

  sc_in_clk     clock;
  sc_out<bool>  qclock;
  sc_out<bool>  hclock;

  sc_uint<3> count;

  void tick( ) {
    hclock = !hclock;
    if( clock & hclock ) qclock = !qclock;
  }

  SC_CTOR( clock_gen ) {
    SC_METHOD( tick );
    sensitive << clock.pos();
  }
};


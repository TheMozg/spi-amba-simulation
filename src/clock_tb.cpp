#include "systemc.h"
#include "clock.cpp"

int sc_main ( int argc, char** argv ) {
  sc_signal<bool> clock;
  sc_signal<bool> qclock_out;
  sc_signal<bool> hclock_out;
  sc_signal<bool> fclock_out;
  int i = 0;

  // Connect the DUT
  clock_gen clk( "CLOCK" );
    clk.clock( clock );
    clk.hclock( hclock_out );
    clk.qclock( qclock_out );

  hclock_out = 0;
  qclock_out = 0;

  sc_start( 1, SC_NS );

  // Open VCD file
  sc_trace_file *wf = sc_create_vcd_trace_file( "clock_gen" );

  // Dump the desired signals
  sc_trace( wf, clock, "clock" );
  sc_trace( wf, hclock_out, "hclock" );
  sc_trace( wf, qclock_out, "qclock" );

  for( i = 0; i < 10; i++ ) {
    clock = 0; 
    sc_start( 1, SC_NS );
    clock = 1; 
    sc_start( 1, SC_NS );
  }

  return 0;
  
}


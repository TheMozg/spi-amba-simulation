#include "systemc.h"
#include "spi.h"
#include "test_spi.h"

#define TRACE_FILE "spi_systemc"

int sc_main ( int argc, char** argv ) {
  
  // Main clock
  sc_clock clock ( "MAIN", 10, SC_NS, 0.5, 10, SC_NS, true );

  // SPI ports
  sc_signal<bool> miso;
  sc_signal<bool> mosi;
  sc_signal<bool> rst;
  sc_signal<bool> start;
  sc_signal<bool> ss;
  sc_signal<bool> sclk;
  sc_signal<bool> busy;
  sc_signal<sc_uint<3> > ctr;

  sc_signal<sc_uint<8> > data_in;
  sc_signal<sc_uint<8> > data_out;

  // Connect the DUT
  spi spi_m( "SPI_MASTER" );
    spi_m.clk( clock );
    spi_m.miso( miso );
    spi_m.mosi( mosi );
    spi_m.rst( rst );
    spi_m.start( start );
    spi_m.ss( ss );
    spi_m.sclk( sclk );
    spi_m.busy( busy );

    spi_m.data_out( data_out );
    spi_m.data_in( data_in );

    spi_m.ctr( ctr );

  test_spi spi_t( "SPI_SLAVE" );
    spi_t.clk( sclk );
    spi_t.miso( miso );
    spi_t.mosi( mosi );
    spi_t.rst( rst );
    spi_t.start( start );
    spi_t.ss( ss );

    spi_t.data_in( data_in );

  // Open VCD file
  sc_trace_file *wf = sc_create_vcd_trace_file( TRACE_FILE );

  // Dump the desired signals
  sc_trace( wf, clock, "clock" );

  sc_trace( wf, miso, "miso" );
  sc_trace( wf, mosi, "mosi" );
  sc_trace( wf, rst, "rst" );
  sc_trace( wf, start, "start" );
  sc_trace( wf, ss, "ss" );
  sc_trace( wf, sclk, "sclk" );
  sc_trace( wf, busy, "busy" );

  sc_trace( wf, data_in, "data_in" );
  sc_trace( wf, data_out, "data_out" );

  sc_start( );

  return 0;
}


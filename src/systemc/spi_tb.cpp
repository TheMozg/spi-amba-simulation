#include "systemc.h"
#include "spi.cpp"
#include "test_slave.cpp"

#define TRACE_FILE "spi"

int sc_main ( int argc, char** argv ) {
  
  // Main clock
  sc_clock clock ("ID", 10, SC_NS, 0.5, 10, SC_NS, true);

  // Test SPI slave ports
  sc_signal<bool> s_clk;
  sc_signal<bool> s_enable;

  // SPI ports
  sc_signal<bool> miso;
  sc_signal<bool> mosi;
  sc_signal<bool> rst;
  sc_signal<bool> enable;
  sc_signal<bool> ss;
  sc_signal<bool> sclk;
  sc_signal<sc_uint<3> > ctr;

  sc_signal<sc_uint<8> > data_in;
  sc_signal<sc_uint<8> > data_out;

  // Connect the DUT
  spi spi_m( "SPI_MASTER" );
    spi_m.clk( clock );
    spi_m.miso( miso );
    spi_m.mosi( mosi );
    spi_m.rst( rst );
    spi_m.enable( enable );
    spi_m.ss( ss );
    spi_m.sclk( sclk );

    spi_m.data_out( data_out );
    spi_m.data_in( data_in );

    spi_m.ctr( ctr );

  test_slave spi_s( "SPI_SLAVE" );
    spi_s.clk( s_clk );
    spi_s.miso( miso );
    spi_s.mosi( mosi );
    spi_s.rst( rst );
    spi_s.enable( enable );
    spi_s.ss( ss );

    spi_s.data_in( data_in );

  clock_gen clk_gen( "CLK_GEN" );
    clk_gen.clock( clock );
    clk_gen.enable( s_enable );
    clk_gen.qclk( s_clk );


  // Open VCD file
  sc_trace_file *wf = sc_create_vcd_trace_file( TRACE_FILE );

  // Dump the desired signals
  sc_trace( wf, clock, "clock" );

  sc_trace( wf, miso, "miso" );
  sc_trace( wf, mosi, "mosi" );
  sc_trace( wf, rst, "rst" );
  sc_trace( wf, enable, "enable" );
  sc_trace( wf, ss, "ss" );
  sc_trace( wf, sclk, "sclk" );
  sc_trace( wf, ctr, "ctr" );

  sc_trace( wf, data_in, "data_in" );
  sc_trace( wf, data_out, "data_out" );

  sc_start( );

  return 0;
}


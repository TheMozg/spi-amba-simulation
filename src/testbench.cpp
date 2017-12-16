#include <iostream>
#include <string>

using namespace std;

#include "systemc.h"
#include "spi_m.h"
#include "bus_amba.h"
#include "test_bus.h"
#include "test_spi.h"

#define TRACE_FILE "testbench"

void bus_tb( );
void spi_tb( );

int sc_main ( int argc, char** argv ) {
  bus_tb( );
  return 0;
}

void bus_tb( ) {
  int i;
  
  // Main clock
  sc_clock clk_m ( "MAIN", 10, SC_NS, 0.5, 10, SC_NS, true );

  // AMBA ports
  sc_signal<bool, SC_MANY_WRITERS> hwrite;
  sc_signal<bool, SC_MANY_WRITERS> hsel[ dev_cnt ];
  sc_signal<bool, SC_MANY_WRITERS> hreset[ dev_cnt ];
  sc_signal<sc_uint<32>, SC_MANY_WRITERS> haddr;
  sc_signal<sc_uint<32>, SC_MANY_WRITERS> hwdata;
  sc_signal<sc_uint<32>, SC_MANY_WRITERS> hrdata;

  // Connect interconnect bus
  bus_amba bus( "BUS_INTER" );
  bus.hclk( clk_m );
  bus.haddr( haddr );
  bus.hwrite( hwrite );
  bus.hwdata( hwdata );
  bus.hrdata( hrdata );
  for( i = 0; i < dev_cnt; i++ ) {
    bus.hsel[i]( hsel[i] );
  }
  for( i = 0; i < dev_cnt; i++ ) {
    bus.hreset[i]( hreset[i] );
  }

  test_bus bus_t( "BUS_TEST" );
  bus_t.clk( clk_m );
  bus_t.haddr( haddr ); 
  bus_t.hwrite( hwrite );
  bus_t.hwdata( hwdata);
  bus_t.hrdata( hrdata);
  
  // Open VCD file
  sc_trace_file *wf = sc_create_vcd_trace_file( TRACE_FILE );

  // Dum main clock
  sc_trace( wf, clk_m, "clk_m" );

  // Dump AMBA signals
  sc_trace( wf, haddr, "haddr" );
  sc_trace( wf, hwrite, "hwrite" );
  sc_trace( wf, hwdata, "hwdata" );
  sc_trace( wf, hrdata, "hrdata" );
  for( i = 0; i < dev_cnt; i++ ) {
    sc_trace( wf, hsel[i], "hsel_" + to_string(i) );
  }
  for( i = 0; i < dev_cnt; i++ ) {
    sc_trace( wf, hreset[i], "hreset_" + to_string(i) );
  }

  sc_start( );

  sc_close_vcd_trace_file( wf );

}

void spi_tb( ) {
  
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

  sc_signal<sc_uint<8> > data_in;
  sc_signal<sc_uint<8> > data_out;

  // Connect the DUT
  spi_m spi_m( "SPI_MASTER" );
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


  test_spi spi_t( "SPI_SLAVE" );
    spi_t.clk( clock );
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
}


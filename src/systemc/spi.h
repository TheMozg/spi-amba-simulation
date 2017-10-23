/* 
  SPI module, working in mode 0 (CPOL = 0, CPHA = 0), master only, transieves 8 bits in 8 cycles.
  Ports:
    clk   -- main input clock
    sclk  -- synchronous clock for interaction between SPI modules. 4 times slower than clk.
    rst   -- reset signal, level sensitive
    busy  -- indicates transaction in progress. 
    ss    -- slave select. Is low for 8 cycles, set to high on last positive sclk edge of transaction.
    start -- signal to start transaction, level sensitive.

    data_in/data_out  -- mosi/miso registers
    mosi/miso -- master out/master in wires. 
                 Set to high on falling edge of sclk, 
                 read happens on falling edge of sclk, 
                 write to data_in/data_out on rising edge of sclk.
*/

#include "systemc.h"
#include "clock.h"

SC_MODULE( spi ) {
  sc_in<sc_uint<8> > data_in;
  sc_out<sc_uint<8> > data_out;

  // Counter for transieving
  sc_out<sc_uint<3> > ctr;

  sc_in<bool> clk, rst, start, miso;
  sc_out<bool> sclk, ss, mosi, busy;

  // SPI clock to generate sclk
  clock_gen clk_gen;

  // Flag for transaction start
  bool toggle_start;

  // Indicate last bit transmission
  bool last;

  void rx( );
  void tx( );
  void reset( );
  void end_transaction( );
  void loop( );

  SC_CTOR( spi ):
  clk( "CLK" ), rst( "RST" ), miso( "MISO" ), sclk( "SCLK" ), 
  ss( "SS" ), mosi( "MOSI" ), clk_gen( "CLK_GEN" ) {

    // Clock generator for sclk
    clk_gen.clock( clk );
    clk_gen.qclk( sclk );

    toggle_start = 0;

    SC_METHOD( loop );
    sensitive << sclk;
  }
};


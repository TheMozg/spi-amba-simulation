// SPI, mode 0, only master mode

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

  // Flag to indicate transaction ending
  bool trans_end;

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

    trans_end = 0;
    toggle_start = 0;

    SC_METHOD( loop );
    sensitive << sclk;
  }
};


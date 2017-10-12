#include "systemc.h"

SC_MODULE( test_spi ) {
  sc_out<bool> miso, rst, enable;
  sc_in<bool> mosi, clk, ss;
  sc_out<sc_uint<8> > data_in;

  uint8_t msg;
  uint8_t counter;

  void demo_send( );
  void test_send( uint8_t in, uint8_t out, bool reset );

  SC_CTOR( test_spi ) {
    SC_THREAD( demo_send );
    sensitive << clk.pos( );
  }

};


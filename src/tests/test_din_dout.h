#pragma once
#include "systemc.h"
#include "din_dout.h"

SC_MODULE( test_din_dout ) {
  sc_in<bool> clk;
  sc_in<bool> hsel;
  sc_out<bool> hwrite;
  sc_out<bool> hreset;
  sc_inout<sc_uint<32> > haddr;
  sc_inout<sc_uint<32> > hwdata;
  sc_inout<sc_uint<32> > hrdata;
  sc_out<sc_uint<16> > switches;
  sc_inout<sc_uint<16> > leds;

  void demo( );

  SC_CTOR( test_din_dout ) {
    din_dout* dig = new din_dout( "DIG" );
    dig->hsel_i( hsel );  
    dig->hclk_i( clk );
    dig->hwrite_i( hwrite );
    dig->haddr_bi( haddr );
    dig->hwdata_bi( hwdata );
    dig->hrdata_bo( hrdata );
    dig->hresetn_i( hreset );
    dig->leds( leds );
    dig->switches( switches );

    SC_THREAD( demo );
    sensitive << clk.pos( );
  }

private:
  void write( int address, int body );
  void read( int address );
};


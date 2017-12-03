#pragma once

#include "systemc.h"

SC_MODULE( test_bus ) {
  sc_in<bool> clk;
  sc_out<bool> hwrite;
  sc_inout<sc_uint<32> > haddr;
  sc_out<sc_uint<32> > hwdata;
  sc_out<sc_uint<32> > hrdata;

  void demo( );

  SC_CTOR( test_bus ) {
    SC_THREAD( demo );
    sensitive << clk.pos( );
  }

private:
  void write( int address, int body );
  void read( int address, int body );
};


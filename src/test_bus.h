#pragma once
#include <systemc.h>
#include "bus_ahb.h"

SC_MODULE( test_bus ) {
  sc_in<bool> clk;
  sc_out<bool> hwrite;
  sc_inout<sc_uint<32> > haddr;
  sc_out<sc_uint<32> > hwdata;
  sc_out<sc_uint<32> > hrdata { "hrdata" };
  sc_out<sc_uint<32> > hrdata_in[ AMBA_DEV_CNT ];

  void demo( );

  SC_CTOR( test_bus ) {
    SC_THREAD( demo );
    sensitive << clk.pos( );
  }

private:
  void write( int address, int body );
  void read( int address, int body, int dev );
};


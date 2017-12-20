/*
  Digital controller for switches and leds control for Nexys4 DDR board.
*/

#pragma once
#include "systemc.h"

// Register map of bus slave
#define DIN_DOUT_IN_REG   0x00000004
#define DIN_DOUT_OUT_REG  0x00000008

SC_MODULE( din_dout ) {
  sc_in<bool> hclk_i;
  sc_in<bool> hresetn_i;
  sc_in<sc_uint<32> >  haddr_bi;
  sc_in<sc_uint<32> >  hwdata_bi;
  sc_out<sc_uint<32> > hrdata_bo;
  sc_in<bool> hwrite_i;
  sc_in<bool> hsel_i;
  
  sc_in<sc_uint<16> > switches { "switches" };
  sc_inout<sc_uint<16> > leds { "leds" };
  
  SC_CTOR( din_dout ) {
    SC_METHOD( bus_slave );
    sensitive << hclk_i.pos( ) << hresetn_i.pos( );
  }
  
  void set_base_address( sc_uint<32> base_addr ) {
    this->base_addr = base_addr;
  }
  
private:
  sc_uint<32> base_addr;

  void bus_slave( );
  
  sc_uint<32> execute_read( sc_uint<16> addr );
  void execute_write( sc_uint<16> addr, sc_uint<32> data );
};


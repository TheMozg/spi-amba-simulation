#pragma once
#include "systemc.h"
#include "dig_ctr.h"

SC_MODULE( test_dig_ctr ) {
  sc_in<bool> clk;
  sc_in<bool> hsel;
  sc_out<bool> hwrite;
  sc_out<bool> hreset;
  sc_inout<sc_uint<32> > haddr;
  sc_inout<sc_uint<32> > hwdata;
  sc_inout<sc_uint<32> > hrdata;

  sc_inout<sc_uint<32> > main_reg;
  sc_inout<sc_uint<32> > ctrl_wires;

  void demo( );

  SC_CTOR( test_dig_ctr ) {
    dig_ctr* dig = new dig_ctr( "DIG" );
    dig->main_reg( main_reg );
    dig->hsel( hsel );  
    dig->hclk( clk );
    dig->hwrite( hwrite );
    dig->haddr( haddr );
    dig->hwdata( hwdata );
    dig->hrdata( hrdata );
    dig->hreset( hreset );
    dig->ctrl_wires( ctrl_wires );

    SC_THREAD( demo );
    sensitive << clk.pos( );
  }

private:
  void write( int address, int body );
  void read( int address, int body );
};


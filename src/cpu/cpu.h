#pragma once
#include "systemc.h"
#include "bus_ahb.h"

SC_MODULE( cpu ) {
  
  sc_in<bool> hclk;
  sc_out<sc_uint<32> >  haddr;
  sc_out<sc_uint<32> >  hwdata;
  sc_in<sc_uint<32> >   hrdata;
  sc_out<bool>          hwrite;

  void software( );

  // AMBA AHB r/w
  uint32_t write( uint32_t address, uint32_t body );
  uint32_t read( uint32_t address );

  // Read data from PmodJSTK
  uint32_t grab_jstk( );

  // Sleep for N cycles
  void sleep( uint32_t cycles );
   
  SC_CTOR( cpu ) {
    haddr.initialize( 0 );
    hwdata.initialize( 0 );
    hwrite.initialize( 0 );
        
    SC_THREAD( software );
    sensitive << hclk.pos( );
  }

};


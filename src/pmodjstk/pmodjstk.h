/*  
    Emulation of PmodJSTK
    Sends the same 5 bytes constantly:
      X as 1110100101
      Y as 1110100101
      buttons as 00000111

    X and Y are 10 bit values, buttons info is in a fifth byte
    First input byte is interpreted as leds statuses
*/
#pragma once

#include <systemc.h>
#include "spi.h"

SC_MODULE( pmodjstk ) {

  spi_s* spi;

  sc_in<bool> clk, sclk, mosi, rst, ss;
  sc_out<bool> miso, busy;

  sc_out<sc_uint<SPI_BIT_CAP> > data_in;
  sc_inout<sc_uint<SPI_BIT_CAP> > data_out { "data_out" };

  sc_uint<8> counter;

  // last 8 bits of X
  sc_uint<8> x_1;

  // first 2 bits of X
  sc_uint<8> x_2;

  // last 8 bits of Y
  sc_uint<8> y_1;

  // first 2 bits of Y
  sc_uint<8> y_2;

  // buttons state (0b00000abc)
  sc_uint<8> buttons;

  void emul( );

  SC_CTOR( pmodjstk ) {
    spi = new spi_s( "PMODJSTK_SPI" );
    spi->clk( clk );
    spi->sclk( sclk );
    spi->rst( rst );
    spi->ss( ss );
    spi->busy( busy );
    
    spi->mosi( mosi );
    spi->miso( miso );
    
    spi->data_in( data_in );
    spi->data_out( data_out );
    
    x_1 = 0b10101010;
    x_2 = 0b00000001;

    y_1 = 0b00110011;
    y_2 = 0b00000010;

    buttons = 0b00000101;
    
    counter = 0;
    SC_METHOD( emul );
    sensitive << sclk.pos( ) 
              << ss.neg( ) 
              << ss.pos( ) 
              << rst.pos( );
  }

  ~pmodjstk( ) {
    delete spi;
  }

};

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

  sc_inout<sc_uint<SPI_BIT_CAP> > data_in;
  sc_out<sc_uint<SPI_BIT_CAP> > data_out { "data_out" };

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

  enum {
    JSTK_EMUL_WAIT_FIRST_BYTE,
    JSTK_EMUL_WAIT_SECOND_BYTE,
    JSTK_EMUL_WAIT_THIRD_BYTE,
    JSTK_EMUL_WAIT_FOURTH_BYTE,
    JSTK_EMUL_WAIT_FIFTH_BYTE,
    JSTK_EMUL_WAIT_FIRST_BYTE_END,
    JSTK_EMUL_WAIT_SECOND_BYTE_END,
    JSTK_EMUL_WAIT_THIRD_BYTE_END,
    JSTK_EMUL_WAIT_FOURTH_BYTE_END,
    JSTK_EMUL_WAIT_FIFTH_BYTE_END
  } fsm_state;

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
    
    fsm_state = JSTK_EMUL_WAIT_FIRST_BYTE;

    x_1 = 0xAD;
    x_2 = 0xDE;

    y_1 = 0xDA;
    y_2 = 0xDE;

    buttons = 0b00000111;
    
    SC_METHOD( emul );
    sensitive << clk.pos( ) << ss.neg( ) << rst.pos( );
  }

  ~pmodjstk( ) {
    delete spi;
  }

};


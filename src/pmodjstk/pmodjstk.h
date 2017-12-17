#pragma once

#include <systemc.h>
#include "spi.h"

SC_MODULE( pmodjstk ) {

  spi_s* spi;

  sc_in<bool> clk, sclk, mosi, rst, ss;
  sc_out<bool> miso;

  void emul( );

  SC_CTOR( pmodjstk ) {
    spi = new spi_s( "PMODJSTK_SPI" );
    spi->clk( clk );
    spi->sclk( sclk );
    spi->rst( rst );
    spi->ss( ss );
    
    spi->mosi( mosi );
    spi->miso( miso );
    
    sensitive << clk.pos( );
  }

  ~pmodjstk( ) {
    delete spi;

  }

};


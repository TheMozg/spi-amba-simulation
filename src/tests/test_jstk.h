#pragma once

#include "systemc.h"
#include "pmodjstk.h"
#include "spi.h"

SC_MODULE( test_jstk ) {
  void demo_send( );
  void test_send( uint8_t in );

  sc_in<bool> clock;
  sc_inout<bool> miso, mosi, rst, ss, sclk;
  sc_out<bool> start, busy_m, busy_s;

  sc_inout<sc_uint<SPI_BIT_CAP> > data_in_m;
  sc_inout<sc_uint<SPI_BIT_CAP> > data_out_m;

  sc_inout<sc_uint<SPI_BIT_CAP> > data_in_s;
  sc_inout<sc_uint<SPI_BIT_CAP> > data_out_s;

  SC_CTOR( test_jstk ) {
    spi_m* m_spi = new spi_m( "SPI_MASTER" );
    m_spi->clk( clock );
    m_spi->miso( miso );
    m_spi->mosi( mosi );
    m_spi->rst( rst );
    m_spi->start( start );
    m_spi->ss( ss );
    m_spi->sclk( sclk );
    m_spi->busy( busy_m );

    m_spi->data_out( data_out_m );
    m_spi->data_in( data_in_m );

    pmodjstk* jstk = new pmodjstk( "PMODJSTK" );
    jstk->clk( clock );
    jstk->miso( miso );
    jstk->mosi( mosi );
    jstk->rst( rst );
    jstk->ss( ss );
    jstk->sclk( sclk );
    jstk->busy( busy_s );

    jstk->data_out( data_out_s );
    jstk->data_in( data_in_s );

    SC_THREAD( demo_send );
    sensitive << clock.pos( );
  }

};


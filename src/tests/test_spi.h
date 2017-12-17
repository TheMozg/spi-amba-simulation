#pragma once

#include "systemc.h"
#include "spi.h"

SC_MODULE( test_spi ) {
  void demo_send( );
  void test_send( uint8_t in, uint8_t out );

  sc_in<bool> clock;
  sc_inout<bool> miso, mosi, rst, ss, sclk;
  sc_out<bool> start, busy_m, busy_s;

  sc_inout<sc_uint<SPI_BIT_CAP> > data_in_m;
  sc_inout<sc_uint<SPI_BIT_CAP> > data_out_m;

  sc_inout<sc_uint<SPI_BIT_CAP> > data_in_s;
  sc_inout<sc_uint<SPI_BIT_CAP> > data_out_s;

  SC_CTOR( test_spi ) {
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

    spi_s* s_spi = new spi_s( "SPI_SLAVE" );
    s_spi->clk( clock );
    s_spi->miso( miso );
    s_spi->mosi( mosi );
    s_spi->rst( rst );
    s_spi->ss( ss );
    s_spi->sclk( sclk );
    s_spi->busy( busy_s );

    s_spi->data_out( data_out_s );
    s_spi->data_in( data_in_s );

    SC_THREAD( demo_send );
    sensitive << clock.pos( );
  }

};


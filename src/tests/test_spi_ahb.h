#pragma once
#include "systemc.h"
#include "spi_ahb.h"
#include "pmodjstk.h"

SC_MODULE( test_spi_ahb ) {

  sc_in<bool> clk { "clk" };
  sc_inout<bool> miso { "miso" };
  sc_inout<bool> mosi { "mosi" }, sclk { "sclk" }, ss { "ss" };
  sc_inout<sc_uint<SPI_BIT_CAP> > data_spi { "data_spi" };
  sc_inout<sc_uint<SPI_BIT_CAP> > data_dummy { "data_dummy" };
  sc_inout<bool> hwrite { "hwrite" }, hsel { "hsel" };
  sc_inout<bool> hreset { "hreset" }; // To send it to SPI rst ports

  sc_inout<sc_uint<32> >  haddr;
  sc_inout<sc_uint<32> >  hwdata { "hwdata" };
  sc_out<sc_uint<32> > hrdata;

  sc_out<bool> js_busy;
  sc_out<bool> sa_busy;
  sc_out<bool> sa_start;
  void demo( );

  SC_CTOR( test_spi_ahb ) {
    spi_ahb* sa = new spi_ahb( "SPI_AHB" );
    pmodjstk* js = new pmodjstk( "PMODJSTK" );
    sa->hsel( hsel );  
    sa->clk( clk );
    sa->miso( miso );
    sa->mosi( mosi );
    sa->sclk( sclk );
    sa->ss( ss );
    sa->data_in( data_spi );
    sa->data_out( data_spi );
    sa->hwrite( hwrite );
    sa->hreset( hreset );
    sa->hwdata( hwdata );
    sa->hrdata( hrdata );
    sa->haddr( haddr );
    sa->busy( sa_busy );
    sa->start( sa_start );

    js->clk( clk );
    js->sclk( sclk );
    js->mosi( mosi );
    js->rst( hreset );
    js->ss( ss );
    js->miso( miso );
    js->data_out( data_spi );
    js->data_in( data_dummy );
    js->busy( js_busy );

    SC_THREAD( demo );
    sensitive << clk.pos( );
  }

private:
  void write( int address, int body );
  void read( int address );
};


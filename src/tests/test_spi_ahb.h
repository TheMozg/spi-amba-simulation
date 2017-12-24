#pragma once
#include "systemc.h"
#include "spi_ahb.h"
#include "pmodjstk.h"

SC_MODULE( test_spi_ahb ) {

  sc_in<bool> clk { "clk" };

  sc_out<bool> start  { "start" };
  sc_out<bool> sa_busy   { "sa_busy" };
  sc_out<bool> js_busy   { "js_busy" };

  // SPI wires (for slave connection)
  sc_inout<bool> miso  { "miso" };
  sc_inout<bool> mosi { "mosi" }, sclk { "sclk" }, ss { "ss" }, rst { "rst" };

  sc_out<sc_uint<SPI_BIT_CAP> > sa_data_out  { "sa_data_out" };
  sc_inout<sc_uint<SPI_BIT_CAP> > sa_data_in { "sa_data_in" };

  sc_inout<sc_uint<SPI_BIT_CAP> > js_data_out  { "js_data_out" };
  sc_out<sc_uint<SPI_BIT_CAP> > js_data_in { "js_data_in" };

  // AMBA AHB compliant ports to connect to AHB bus
  sc_inout<bool> hwrite { "hwrite" }, hsel { "hsel" };
  sc_inout<bool> n_hreset { "n_hreset" }; // To send it to SPI rst ports

  sc_inout<sc_uint<32> >  haddr  { "haddr" };
  sc_inout<sc_uint<32> >  hwdata { "hwdata" };
  sc_out<sc_uint<32> > hrdata { "hrdata" };


  void demo( );

  SC_CTOR( test_spi_ahb ) {
    spi_ahb* sa = new spi_ahb( "SPI_AHB" );
    pmodjstk* js = new pmodjstk( "PMODJSTK" );

    n_hreset.initialize( 1 );
    sa->clk( clk );
    sa->start( start );
    sa->busy( sa_busy );
    sa->miso( miso );
    sa->mosi( mosi );
    sa->sclk( sclk );
    sa->ss( ss );
    sa->rst( rst );
    sa->data_out( sa_data_out );
    sa->data_in( sa_data_in );
    sa->hwrite( hwrite );
    sa->hsel( hsel );
    sa->n_hreset( n_hreset );
    sa->haddr( haddr );
    sa->hwdata( hwdata );
    sa->hrdata( hrdata );

    js->clk( clk );
    js->sclk( sclk );
    js->mosi( mosi );
    js->miso( miso );
    js->rst( n_hreset );
    js->ss( ss );
    js->busy(js_busy );
    js->data_in( js_data_in );
    js->data_out( js_data_out );

    SC_THREAD( demo );
    sensitive << clk.pos( );
  }

private:
  void write( int address, int body );
  void read( int address );
};


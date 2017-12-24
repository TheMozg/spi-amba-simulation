/*
  Controller to connect SPI slave device to AMBA AHB bus
*/

#pragma once
#include "systemc.h"
#include "spi.h"

// Register map
#define SPI_AHB_START     0x00000000  // Write-only
#define SPI_AHB_SS        0x00000004
#define SPI_AHB_READY     0x00000008  // Read-only
#define SPI_AHB_DATA      0x00000012  // Read-only

SC_MODULE( spi_ahb ) {

  // SPI master to connect to peripheral device
  spi_m* spi;

  sc_in<bool> clk { "clk" };

  sc_out<bool> start  { "start" };
  sc_out<bool> busy   { "busy" };

  // SPI wires (for slave connection)
  sc_in<bool> miso  { "miso" };
  sc_out<bool> mosi { "mosi" }, sclk { "sclk" }, ss { "ss" }, rst { "rst" };

  sc_out<sc_uint<SPI_BIT_CAP> > data_out  { "data_out" };
  sc_inout<sc_uint<SPI_BIT_CAP> > data_in { "data_in" };

  // AMBA AHB compliant ports to connect to AHB bus
  sc_in<bool> hwrite { "hwrite" }, hsel { "hsel" };
  sc_inout<bool> n_hreset { "n_hreset" }; // To send it to SPI rst ports

  sc_in<sc_uint<32> >  haddr  { "haddr" };
  sc_in<sc_uint<32> >  hwdata { "hwdata" };
  sc_out<sc_uint<32> > hrdata { "hrdata" };

  sc_uint<1> ready; // Indicates that SPI transaction is finished

  sc_uint<32> buf_data;
  sc_uint<32> buf_addr;
  sc_uint<1> buf_start;

  enum {
    SPI_AHB_IDLE,
    SPI_AHB_READ,
    SPI_AHB_WRITE_START,
    SPI_AHB_WRITE_DONE
  } fsm_state;

  void fsm( );
  void read( sc_uint<12> addr );
  void write( sc_uint<12> addr );

  SC_CTOR( spi_ahb ) {
    fsm_state = SPI_AHB_IDLE;

    spi = new spi_m( "SPI_AHB_MASTER" );
    spi->clk( clk );
    spi->miso( miso );
    spi->mosi( mosi );
    spi->start( start );
    spi->sclk( sclk );
    spi->ss( ss );
    spi->rst( rst );
    spi->busy( busy );
    spi->data_out( data_out );
    spi->data_in( data_in );
    
    SC_METHOD( fsm );
    sensitive << clk.pos( )
              << n_hreset.neg( )
              << busy.neg( );
  }

};


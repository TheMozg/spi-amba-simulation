/*
  Controller to connect SPI slave device to AMBA AHB bus

  This controller is designed to work with PmodJSTK.
  PmodJSTK doesn't support any input, so only read operation is supported.
*/
#pragma once
#include "systemc.h"
#include "spi.h"

// Register map
#define SPI_AHB_START     0x00000000
#define SPI_AHB_READY     0x00000004
#define SPI_AHB_X         0x00000008
#define SPI_AHB_Y         0x00000012
#define SPI_AHB_BUTTONS   0x00000016

SC_MODULE( spi_ahb ) {

  // SPI master to connect to peripheral device
  spi_m* spi;

  sc_in<bool> clk { "clk" };

  sc_out<bool> start { "start" };
  sc_out<bool> busy { "busy" };

  // SPI wires (for slave connection)
  sc_in<bool> miso { "miso" };
  sc_out<bool> mosi { "mosi" }, sclk { "sclk" }, ss { "ss" };
  //sc_in<bool> rst;
  sc_out<sc_uint<SPI_BIT_CAP> > data_out { "data_out" };
  sc_in<sc_uint<SPI_BIT_CAP> > data_in { "data_in" };

  //sc_out<bool> ready;

  // AMBA AHB compliant ports to connect to AHB bus
  sc_in<bool> hwrite { "hwrite" }, hsel { "hsel" };
  sc_inout<bool> hreset { "hreset" }; // To send it to SPI rst ports

  sc_in<sc_uint<32> >  haddr { "haddr" };
  sc_in<sc_uint<32> >  hwdata { "hwdata" };
  sc_out<sc_uint<32> > hrdata { "hrdata" };

  sc_uint<16> x_data;
  sc_uint<16> y_data;
  sc_uint<8> buttons_data;
  sc_uint<8> ready; // Indicates that SPI transaction is finished

 // sc_uint<32> buf_data;
  sc_uint<32> buf_addr;

  // Counter to count 5 bytes transaction
  char ctr;

  enum {
    SPI_AHB_IDLE,
    SPI_AHB_WAITING_END,
    SPI_AHB_READ,
    SPI_AHB_WRITE
  } fsm_state;

  void fsm( );
  void read( sc_uint<16> addr );

  SC_CTOR( spi_ahb ) {
    fsm_state = SPI_AHB_IDLE;
    ctr = 0;
    spi = new spi_m( "SPI_AHB_MASTER" );
    spi->clk( clk );
    spi->miso( miso );
    spi->mosi( mosi );
    spi->start( start );
    spi->sclk( sclk );
    spi->ss( ss );
    spi->rst( hreset );
    spi->busy( busy );
    spi->data_out( data_out );
    spi->data_in( data_in );
    
    SC_METHOD( fsm );
    sensitive << clk.pos( )
              << hreset.pos( )
              << busy.neg( );
  }

};


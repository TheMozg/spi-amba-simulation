#pragma once
/* 
  SPI module, working in mode 0 (CPOL = 0, CPHA = 0), transieves 8 bits in 8 cycles.
  Ports:
    clk   -- main input clock
    sclk  -- synchronous clock for interaction between SPI modules. 4 times slower than clk.
    rst   -- reset signal, edge sensitive
    busy  -- indicates transaction in progress. 
    ss    -- slave select. Is low for 8 cycles, set to high on last positive sclk edge of transaction.
    start -- signal to start transaction, edge sensitive.

    data_in/data_out  -- mosi/miso registers
    mosi/miso -- master out/master in wires. 
                 Set to high on falling edge of sclk, 
                 read happens on falling edge of sclk, 
                 write to data_in/data_out on rising edge of sclk.
*/

#include "systemc.h"
#include "div_clk.h"

// Base struct
struct spi : public sc_module {
  SC_HAS_PROCESS( spi );

  // SPI wires
  sc_in<bool> clk, rst;
  sc_out<bool> busy;

  // Shift register
  sc_uint<8> shift_reg;

  // Outputs for shift_reg
  sc_in<sc_uint<8> > data_in;
  sc_out<sc_uint<8> > data_out;

  // Transaction counter
  sc_uint<4> tr_ctr;

  // Buffer register
  bool reg_buf;

  sc_uint<2> fsm_state;

  void rx_write( );
  void reset( );
  void tx_shift( );

  virtual void rx_capture( ) { };
  virtual void tx( ) { };

  virtual void loop( ) { };
  virtual void end_transaction( ) { };

  enum {
    SPI_IDLE,
    SPI_WAIT_SCLK_1,
    SPI_WAIT_SCLK_0,
    SPI_FINAL 
  };

  spi( const sc_module_name& name ) : sc_module( name ) {

    SC_METHOD( loop );
    sensitive << clk.pos( ) 
              << rst.pos( );
  }

};

// Master SPI
struct spi_m : public spi {

  SC_HAS_PROCESS( spi_m );

  sc_in<bool> miso, start;
  sc_out<bool> mosi, sclk, ss;

  // If module just started
  // Is equired for SS set
  bool cold_run = 1;

  // SPI clock divider to generate sclk
  div_clk* clk_gen;

  void loop( );
  void end_transaction( );
  void rx_capture( );
  void tx( );

  spi_m( const sc_module_name& name ) : spi( name ) {
    clk_gen = new div_clk( "DIV_CLK" );

    // Clock generator for sclk
    clk_gen->enable( busy );
    clk_gen->clock( clk );
    clk_gen->qclk( sclk );

    sensitive << sclk.pos( ) 
              << sclk.neg( )
              << start.pos( );
  }

  ~spi_m( ) {
    delete clk_gen;
  }

};

// Slave SPI
struct spi_s : public spi {

  SC_HAS_PROCESS( spi_s );

  sc_in<bool> mosi, sclk, ss;
  sc_out<bool> miso;

  void loop( );
  void end_transaction( );
  void rx_capture( );
  void tx( );

  spi_s( const sc_module_name& name ) : spi( name ) {
    sensitive << sclk.pos( ) 
              << sclk.neg( );
  }

};


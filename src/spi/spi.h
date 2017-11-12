#pragma once
/* 
  SPI module, working in mode 0 (CPOL = 0, CPHA = 0), master only, transieves 8 bits in 8 cycles.
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

SC_MODULE( spi ) {
  // SPI wires
  sc_in<bool> clk, rst, start, miso;
  sc_out<bool> sclk, ss, mosi, busy;

  // Shift register
  sc_uint<8> shift_reg;

  // Outputs for shift_reg
  sc_in<sc_uint<8> > data_in;
  sc_out<sc_uint<8> > data_out;

  // Transaction counter
  sc_uint<4> tr_ctr;

  // SPI clock divider to generate sclk
  div_clk clk_gen;

  // Buffer register
  bool reg_buf;

  sc_uint<2> fsm_state;

  void rx_capture( );
  void rx_write( );
  void tx( );
  void reset( );
  void end_transaction( );
  void loop( );

  enum {
    STATE_IDLE,
    STATE_WAIT_SCLK_1,
    STATE_WAIT_SCLK_0,
    STATE_FINAL 
  };

  SC_CTOR( spi ):
  clk( "CLK" ), rst( "RST" ), miso( "MISO" ), sclk( "SCLK" ), 
  ss( "SS" ), mosi( "MOSI" ), clk_gen( "CLK_GEN" ) {

    // Clock generator for sclk
    clk_gen.enable( busy );
    clk_gen.clock( clk );
    clk_gen.qclk( sclk );

    SC_METHOD( loop );
    sensitive << clk.pos( ) 
              << rst.pos( ) 
              << start.pos( ) 
              << sclk.pos( ) 
              << sclk.neg( );
  }
};


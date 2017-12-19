/*
  Digital controller for switches and leds control for Nexys4 DDR board.

  Memory map:
    0x0000 [7:0] -- byte to send
    0x0004 [7:0] -- received byte
    0x0008 [0] -- start bit, starts sending
           [1] -- ready bit, defines if device is ready for sending
           [2] -- error bit, defines if error has happened during last transaction
    
  If writing to 0x0008 reading only first bit of byte and ignoring others
*/

#pragma once
#include "systemc.h"

#define SEND_BYTE_ADDR 0x0000
#define RECEIVE_BYTE_ADDR 0x0004
#define CTRL_BYTE_ADDR 0x0008

const unsigned char led_cmd = 0b1;
const unsigned char switches_cmd = 0b10;

SC_MODULE( dig_ctr ) {
  
  // AMBA AHB compliant inputs and registers
  sc_in<bool> hclk;
  sc_in<bool> hwrite;
  sc_in<bool> hsel;
  sc_in<bool> hreset;

  sc_in<sc_uint<32> >   haddr;
  sc_in<sc_uint<32> >   hwdata;
  sc_out<sc_uint<32> >  hrdata;

  sc_uint<32> buf_addr;
  sc_uint<32> buf_data;

  // Memory register
  sc_out<sc_uint<32> >  main_reg { "main_reg" };

  // Leds and switches wires
  sc_inout<sc_uint<32> > ctrl_wires { "ctrl_wires" };

  // Offsets for grabbing required bytes from main register
  enum {
    SEND_OFFSET = 0,
    RECEIVE_OFFSET = 8,
    CTRL_OFFSET = 16,
    START_BIT_OFFSET = 16,
    READY_BIT_OFFSET = 17,
    ERROR_BIT_OFFSET = 18
  } offset;

  enum {
    CTR_READ,
    CTR_WRITE
  } status;

  enum {
    CTR_IDLE,
    CTR_DATA,
    CTR_ADDR
  } fsm_state;

  bool start;
  bool error;
  bool ready;

  // Select byte to interact with
  void byte_select( );
  void fsm( );
  void dump_control( );

  SC_CTOR( dig_ctr ) {
    status = CTR_READ;
    start = 0;
    error = 0;
    ready = 0;   
    buf_addr = 0;

    fsm_state = CTR_IDLE;
    //ctrl_wires.write( 0 );

    offset = SEND_OFFSET;

    SC_METHOD( byte_select );
    sensitive << hsel.pos( );

    SC_METHOD( fsm );
    sensitive << hclk.pos( ),
                 hreset.pos( );
  }

};


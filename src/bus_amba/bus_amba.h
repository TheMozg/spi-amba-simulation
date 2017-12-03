#pragma once
#include <systemc.h>

#define DEVICE_COUNT 3

// Set dev base adress as first 20 bits
// 0x40000000 -- 0x400000FFF
#define DEV1_BASE_ADDR_PREFIX 0x40000
// 0x50000000 -- 0x500000FFF
#define DEV2_BASE_ADDR_PREFIX 0x50000
// 0x60000000 -- 0x600000FFF
#define DEV3_BASE_ADDR_PREFIX 0x60000

SC_MODULE( bus_amba ) {
  sc_in<bool> hclk;
  sc_inout<bool> hwrite;

  sc_inout<sc_uint<32> > haddr;
  sc_out<sc_uint<32> > hwdata;
  sc_in<sc_uint<32> > hwdata_buf;
  sc_out<sc_uint<32> > hrdata;
  sc_out<sc_uint<32> > hrdata_buf;

  sc_out<bool> hsel[ DEVICE_COUNT ];
  sc_out<bool> hreset[ DEVICE_COUNT ];

  enum fsm_state {
    AMBA_IDLE,
    AMBA_READ_ADR,
    AMBA_READ_DATA,
    AMBA_WRITE_ADR,
    AMBA_WRITE_DATA
  };

  enum fsm_state bus_state;

  SC_CTOR( bus_amba ): hclk( "hclk" ), hwrite( "hwrite" ) {
    bus_state = AMBA_IDLE;

    SC_METHOD( bus_fsm );
    sensitive << hclk.pos( );

    SC_METHOD( dev_select );
    sensitive << haddr;

  }

  void bus_fsm( );
  void dev_select( );

private:
  void reset_hsel( );
  void amba_idle( );
  void amba_write_address( );
  void amba_read_address( );
};


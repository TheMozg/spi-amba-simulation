/*
  AMBA AHB bus controller.
*/

#pragma once
#include "systemc.h"

#define AMBA_DEV_CNT dev_cnt

// How many devices are interconnected by AHB bus
const char dev_cnt = 3;

// How many bits are for device address and how many for inner address of device
const char dev_inner_addr_size  = 12;
const char dev_dev_addr_size    = 20;

// Device memory start address and mask for inner address
const uint32_t dev_addr_start       = 0x40000000;
const uint32_t dev_inner_addr_mask  = 0xFFFFFFFF >> dev_dev_addr_size;

// Device memory map
// For example 
// device 0 memory will be 0x40000000 -- 0x40000FFF, 
// device 1 0x40001000 -- 0x40001FFF and so on
struct dev_addr_map_t {
  uint32_t index;   // Device index
  uint32_t base;    // Device memory base address
  uint32_t end;     // Device memory end address
  uint32_t prefix;  // Device memory prefix (e.g. first 20 bits )
};

// Devices on the bus
static dev_addr_map_t *devs = new dev_addr_map_t[dev_cnt];

SC_MODULE( bus_ahb ) {
  // AHB ports
  sc_in<bool>     hclk, hreset;
  sc_inout<bool>  hwrite;
  sc_out<bool>    hsel[ dev_cnt ];

  sc_inout<sc_uint<32> >  haddr       { "haddr" };
  sc_out<sc_uint<32> >    hwdata      { "hwdata" };
  sc_out<sc_uint<32> >    hrdata_out  { "hrdata_out" };
  sc_in<sc_uint<32> >     hrdata_in[ dev_cnt ];
  
  // Address buffer
  sc_uint<dev_dev_addr_size+dev_inner_addr_size> buf_haddr;

  // Address index buffer to select HRDATAx line
  uint32_t buf_index;

  // Transaction FSM states
  enum {
    AHB_IDLE,
    AHB_READ_ADR,
    AHB_READ_DATA,
    AHB_WRITE_ADR,
    AHB_WRITE_DATA
  } bus_state;

  SC_CTOR( bus_ahb ): hclk( "hclk" ), hwrite( "hwrite" ) {
    init_dev( );

    buf_index = 0;
    buf_haddr = 0;

    bus_state = AHB_IDLE;

    SC_METHOD( fsm );
    sensitive << hclk.pos( );

    SC_METHOD( dev_select );
    sensitive << haddr;
  }

  // Main transaction loop
  void fsm( );

private:
  void init_dev( );   // Register devices on the bus
  void dev_select( ); // Select slave device (decoder)
  void reset_hsel( ); // Reset device select lines
  void amba_idle( );  // Start read/write transaction from idle state
  void amba_write_address( ); // Address phase of write transaction
  void amba_read_address( );  // Address phase of read transaction
};


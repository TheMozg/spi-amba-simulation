#pragma once
#include <systemc.h>

// How many devices are interconnected by AMBA bus
const char dev_cnt = 3;

// How many bits are for device address and how many for inner address of device
const char dev_inner_addr_size  = 12;
const char dev_dev_addr_size    = 20;

// Device memory start address and mask for inner address
const uint32_t dev_addr_start       = 0x40000000;
const uint32_t dev_inner_addr_mask  = 0xFFFFFFFF >> dev_dev_addr_size;

// Device memory map
// Registering devices according to DEV* macros
// For example 
// device 0 memory will be 0x40000000 -- 0x40000FFF, 
// device 2 0x40001000 -- 0x40001FFF and so on
struct dev_addr_map_t {
  uint32_t index;   // Device index
  uint32_t base;    // Device memory base address
  uint32_t end;     // Device memory end address
  uint32_t prefix;  // Device memory prefix (e.g. first 20 bits )
};

static dev_addr_map_t *devs = new dev_addr_map_t[dev_cnt];

SC_MODULE( bus_amba ) {
  sc_in<bool>     hclk;
  sc_inout<bool>  hwrite;
  sc_out<bool>    hsel[ dev_cnt ];
  sc_out<bool>    hreset[ dev_cnt ];

  sc_inout<sc_uint<32> >  haddr;
  sc_out<sc_uint<32> >    hwdata;
  sc_out<sc_uint<32> >    hrdata;

  enum fsm_state {
    AMBA_IDLE,
    AMBA_READ_ADR,
    AMBA_READ_DATA,
    AMBA_WRITE_ADR,
    AMBA_WRITE_DATA
  } bus_state;

  SC_CTOR( bus_amba ): hclk( "hclk" ), hwrite( "hwrite" ) {
    init_dev( );
    bus_state = AMBA_IDLE;

    SC_METHOD( bus_fsm );
    sensitive << hclk.pos( );

    SC_METHOD( dev_select );
    sensitive << haddr;
  }

  void bus_fsm( );

private:
  void init_dev( );
  void dev_select( );
  void reset_hsel( );
  void amba_idle( );
  void amba_write_address( );
  void amba_read_address( );
};


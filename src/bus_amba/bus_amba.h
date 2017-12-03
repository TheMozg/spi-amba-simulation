#pragma once
#include <systemc.h>

// How many devices are interconnected by AMBA bus
#define DEV_CNT 3

#define DEV_INNER_ADDR_SIZE 12
#define DEV_DEV_ADDR_SIZE   20

#define DEV_ADDR_START      0x40000000
#define DEV_INNER_ADDR_MASK 0x00000FFF

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

static dev_addr_map_t *devs = new dev_addr_map_t[DEV_CNT];

SC_MODULE( bus_amba ) {
  sc_in<bool> hclk;
  sc_inout<bool> hwrite;

  sc_inout<sc_uint<32> >  haddr;
  sc_out<sc_uint<32> >    hwdata;
  sc_in<sc_uint<32> >     hwdata_buf; // Not sure this is needed
  sc_out<sc_uint<32> >    hrdata;
  sc_out<sc_uint<32> >    hrdata_buf; // Not sure this is needed

  sc_out<bool> hsel[ DEV_CNT ];
  sc_out<bool> hreset[ DEV_CNT ];

  enum fsm_state {
    AMBA_IDLE,
    AMBA_READ_ADR,
    AMBA_READ_DATA,
    AMBA_WRITE_ADR,
    AMBA_WRITE_DATA
  };

  enum fsm_state bus_state;

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


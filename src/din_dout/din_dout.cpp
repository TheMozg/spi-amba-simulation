#include <cstdio>
#include "din_dout.h"

void din_dout::bus_slave( ) {
  static bool wr_flag = false;
  static sc_uint<32> wr_addr = 0;
  
  if ( !n_hreset_i.read( ) ) {
    wr_flag = false;
    wr_addr = 0;
    
    leds.write( 0 );
    return;
  } 

  if ( hclk_i.read( ) && hsel_i.read( ) ) {
    if ( wr_flag ) {
      execute_write( ( sc_uint<16> )( wr_addr - base_addr ), hwdata_bi.read( ) );
      wr_flag = false;
    }
    
    if ( hwrite_i.read( ) ) {
      wr_flag = true;
      wr_addr = haddr_bi.read( );
    } else {
      hrdata_bo.write( ( sc_uint<16> )( execute_read( haddr_bi.read( ) - base_addr ) ) );
    }
  }

}

sc_uint<32> din_dout::execute_read( sc_uint<16> addr ) {
  sc_uint<32> data;

#ifdef DIN_DOUT_DEBUG
  printf("DINDOUT read: addr: 0x%08X\n", (unsigned short) addr );
#endif
  switch( addr ) {
    case DIN_DOUT_IN_REG:
      data = switches.read( );
      break;
    
    case DIN_DOUT_OUT_REG:
      data = leds.read( );
      break;
    
    default:
      data = 0;
      break;
  }
#ifdef DIN_DOUT_DEBUG
  printf("DINDOUT read: data: 0x%08X\n", (uint32_t) data );
#endif
  
  return data;
}

void din_dout::execute_write( sc_uint<16> addr, sc_uint<32> data ) {
#ifdef DIN_DOUT_DEBUG
  printf("DINDOUT write: addr: 0x%08X, data: 0x%08X\n", (unsigned short) addr, (uint32_t) data );
#endif
  switch( addr ) {
    
    case DIN_DOUT_OUT_REG:
      leds.write( data );
      break;
    
    default:
      break;
  }
}


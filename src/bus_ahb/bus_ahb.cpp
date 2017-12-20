#include "bus_ahb.h"

void bus_ahb::init_dev( ) {
  uint32_t base = dev_addr_start;
  for( int i = 0; i < dev_cnt; i++ ) {
    dev_addr_map_t dev;
    dev.base = base;
    dev.end = dev.base | dev_inner_addr_mask;
    dev.prefix = base >> dev_inner_addr_size;
    devs[i] = dev;
    base = ( ( base >> dev_inner_addr_size ) + 1 ) << dev_inner_addr_size;
    cout << "Registered device " << dec << i << " at " << hex << dev.base << " -- " << dev.end 
         << " prefix " << dev.prefix << endl;
  } 
}

void bus_ahb::reset_hsel( ) {
  for( int i = 0; i < dev_cnt; i++ ) hsel[i].write( 0 );
}

void bus_ahb::amba_idle( ) {

#ifdef AHB_DEBUG
  cout << "AHB IDLE: " << bus_state << endl;
#endif

  for( int i = 0; i < dev_cnt; i++ ) {
    if( hsel[i].read( ) ) {

#ifdef AHB_DEBUG
      cout << "\tAHB IDLE HSEL_" << i << ": " << bus_state << endl;
#endif

      bus_state = hwrite.read( ) ? AHB_WRITE_ADR : AHB_READ_ADR;
    }
  }

  reset_hsel( );
}

void bus_ahb::amba_write_address( ) {

#ifdef AHB_DEBUG
  cout << "AHB WRITE ADDRESS: " << bus_state << endl;
#endif

  haddr.write( 0 );
  hwrite.write( 0 );

}

void bus_ahb::amba_read_address( ) {

#ifdef AHB_DEBUG
  cout << "AHB READ ADDRESS: " << bus_state << endl;
#endif

  haddr.write( 0 );
  hwrite.write( 0 );

}

void bus_ahb::fsm( ) {

#ifdef AHB_DEBUG
  cout << "AHB FSM: " << bus_state << endl;
#endif

  if( bus_state == AHB_IDLE ) amba_idle( );

  switch( bus_state ) {

    case AHB_WRITE_ADR:
      amba_write_address( );
      bus_state = AHB_WRITE_DATA;     
      break;
    
    case AHB_WRITE_DATA:
      bus_state = AHB_IDLE;
      break;

    case AHB_READ_ADR:
      amba_read_address( );
      bus_state = AHB_READ_DATA;
      break;

    case AHB_READ_DATA:
      bus_state = AHB_IDLE;
      break;

    default:
      break;
  } 
}
 
void bus_ahb::dev_select( ) {
  sc_uint<dev_dev_addr_size> dev_prefix = haddr.read( ) >> dev_inner_addr_size;

  if( bus_state == AHB_IDLE ) {
    for( int i = 0; i < dev_cnt; i++ ) { 
      hsel[i] = ( dev_prefix == devs[i].prefix ) ? 1 : 0;
    }
  }
#ifdef AHB_DEBUG
  cout << "AHB DEVSEL: addr: " << hex << haddr.read( ) << endl;
  cout << "AHB DEVSEL: base addr: " << hex << dev_prefix << endl;
#endif

}


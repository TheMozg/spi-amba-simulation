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

#ifdef AMBA_DEBUG
  cout << "AMBA IDLE: " << bus_state << endl;
#endif

  for( int i = 0; i < dev_cnt; i++ ) {
    if( hsel[i].read( ) ) {

#ifdef AMBA_DEBUG
      cout << "\tAMBA IDLE HSEL_" << i << ": " << bus_state << endl;
#endif

      bus_state = hwrite.read( ) ? AMBA_WRITE_ADR : AMBA_READ_ADR;
    }
  }

}

void bus_ahb::amba_write_address( ) {

#ifdef AMBA_DEBUG
  cout << "AMBA WRITE ADDRESS: " << bus_state << endl;
#endif

  haddr.write( 0 );
  hwrite.write( 0 );

}

void bus_ahb::amba_read_address( ) {

#ifdef AMBA_DEBUG
  cout << "AMBA READ ADDRESS: " << bus_state << endl;
#endif

  haddr.write( 0 );
  hwrite.write( 0 );

}

void bus_ahb::bus_fsm( ) {

#ifdef AMBA_DEBUG
  cout << "AMBA FSM: " << bus_state << endl;
#endif

  if( bus_state == AMBA_IDLE ) amba_idle( );

  switch( bus_state ) {
    case AMBA_WRITE_ADR:
      amba_write_address( );
      bus_state = AMBA_WRITE_DATA;     
      break;
    
    case AMBA_WRITE_DATA:
      reset_hsel( );
      bus_state = AMBA_IDLE;
      break;

    case AMBA_READ_ADR:
      amba_read_address( );
      bus_state = AMBA_READ_DATA;
      break;

    case AMBA_READ_DATA:
      reset_hsel( );
      bus_state = AMBA_IDLE;
      break;

    default:
      break;
  } 
}
 
void bus_ahb::dev_select( ) {
  sc_uint<dev_dev_addr_size> dev_prefix = haddr.read( ) >> dev_inner_addr_size;

  for( int i = 0; i < dev_cnt; i++ ) { 
    hsel[i] = ( dev_prefix == devs[i].prefix ) ? 1 : 0;
  }

#ifdef AMBA_DEBUG
  cout << "AMBA DEVSEL: addr: " << hex << haddr.read( ) << endl;
  cout << "AMBA DEVSEL: base addr: " << hex << dev_prefix << endl;
#endif

}


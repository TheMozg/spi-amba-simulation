#include "bus_ahb.h"

void bus_ahb::init_dev( ) {
  uint32_t base = dev_addr_start;
  for( int i = 0; i < dev_cnt; i++ ) {
    dev_addr_map_t dev;
    dev.base = base;
    dev.end = dev.base | dev_inner_addr_mask;
    dev.prefix = base >> dev_inner_addr_size;
    devs[i] = dev;
    base = ( ( base >> dev_inner_addr_size ) + 0x1 ) << dev_inner_addr_size;
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

void bus_ahb::fsm( ) {

#ifdef AHB_DEBUG
  cout << "AHB FSM: " << bus_state << endl;
#endif
  
  if( !n_hreset ) {
    reset_hsel( );
    bus_state = AHB_IDLE;
    return;
  }

  if( bus_state == AHB_IDLE ) {
    amba_idle( );
  }

  switch( bus_state ) {

    case AHB_WRITE_ADR:
      bus_state = AHB_WRITE_DATA;     
      break;
    
    case AHB_WRITE_DATA:
      amba_idle( );
      bus_state = AHB_IDLE;
      break;

    case AHB_READ_ADR:
      bus_state = AHB_READ_DATA;
      break;

    case AHB_READ_DATA:
      amba_idle( );
      bus_state = AHB_IDLE;
      break;


    default:
      break;
  } 
}

void bus_ahb::hrdata_multiplexer( ) {
    hrdata_out.write( hrdata_in[buf_index].read());
}
 
void bus_ahb::dev_select( ) {
  buf_haddr = haddr.read( );

  for( int i = 0; i < dev_cnt; i++ ) { 
    if( buf_haddr >> dev_inner_addr_size == devs[i].prefix ) {
      hsel[i].write( 1 );
      buf_index = i;      
    } else {
      hsel[i].write( 0 );
    }
  }
#ifdef AHB_DEBUG
  cout << "AHB DEVSEL: addr: " << hex << buf_haddr << endl;
  cout << "AHB DEVSEL: base addr: " << hex << ( buf_haddr >> dev_inner_addr_size ) << endl;
  cout << "AHB DEVSEL: index: " << buf_index << endl;
#endif

}

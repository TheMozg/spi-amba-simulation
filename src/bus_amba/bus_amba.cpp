#include "bus_amba.h"

void bus_amba::init_dev( ) {
  uint32_t base = dev_addr_start;
  for( int i = 0; i < dev_cnt; i++ ) {
    dev_addr_map_t dev;
    dev.base = base;
    dev.end = dev.base | dev_inner_addr_mask;
    dev.prefix = base >> dev_inner_addr_size;
    devs[i] = dev;
    base = ( ( base >> dev_inner_addr_size ) + 1 ) << dev_inner_addr_size;
    cout << "Registered device " << i << " at " << hex << dev.base << " -- " << dev.end 
         << " prefix " << dev.prefix << " global inner addr mask " << dev_inner_addr_mask << endl;
  } 
}

// Reset device select lines
void bus_amba::reset_hsel( ) {

  for( int i = 0; i < dev_cnt; i++ ) {
    if( hsel[i].read( ) ) {
      hsel[i].write( 0 );
      break;
    }
  }

}

// Start read/write transaction from idle state
void bus_amba::amba_idle( ) {

  //cout << "AMBA IDLE: " << bus_state << endl;
  for( int i = 0; i < dev_cnt; i++ ) {
    if( hsel[i].read( ) ) {
      //cout << "\tAMBA IDLE HSEL_" << i << ": " << bus_state << endl;
      bus_state = hwrite.read( ) ? AMBA_WRITE_ADR : AMBA_READ_ADR;
    }
  }

}

// Address phase of write transaction
void bus_amba::amba_write_address( ) {

  //cout << "AMBA WRITE ADDRESS: " << bus_state << endl;
  haddr.write( 0 );
  hwrite.write( 0 );

}

// Address phase of read transaction
void bus_amba::amba_read_address( ) {

  //cout << "AMBA READ ADDRESS: " << bus_state << endl;
  haddr.write( 0 );
  hwrite.write( 0 );
  //hrdata.write( hrdata_buf.read( ) );

}

// Main transaction loop
void bus_amba::bus_fsm( ) {

  //cout << "AMBA FSM: " << bus_state << endl;
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
 
// Select slave device
void bus_amba::dev_select( ) {
  sc_uint<dev_dev_addr_size> dev_prefix = haddr.read( ) >> dev_inner_addr_size;

  for( int i = 0; i < dev_cnt; i++ ) { 
    hsel[i] = ( dev_prefix == devs[i].prefix ) ? 1 : 0;
  }

  //cout << "AMBA DEVSEL: addr: " << hex << haddr.read( ) << endl;
  //cout << "AMBA DEVSEL: base addr: " << hex << dev_prefix << endl;

}


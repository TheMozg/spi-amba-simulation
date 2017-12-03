#include "bus_amba.h"

// Reset device select lines
void bus_amba::reset_hsel( ) {

  for( int i = 0; i < DEVICE_COUNT; i++ ) {
    if( hsel[i].read( ) ) {
      hsel[i].write( 0 );
      break;
    }
  }

}

// Start read/write transaction from idle state
void bus_amba::amba_idle( ) {

  //cout << "AMBA IDLE: " << bus_state << endl;
  for( int i = 0; i < DEVICE_COUNT; i++ ) {
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
  hwdata.write( hwdata_buf.read( ) ); 

}

// Data phase of write transaction
void bus_amba::amba_write_data( ) {

  //cout << "AMBA WRITE DATA: " << bus_state << endl;
  reset_hsel( );

}

// Address phase of read transaction
void bus_amba::amba_read_address( ) {

  //cout << "AMBA READ ADDRESS: " << bus_state << endl;
  haddr.write( 0 );
  hwrite.write( 0 );
  hrdata.write( hrdata_buf.read( ) );

}

// Data phase of read transaction
void bus_amba::amba_read_data( ) {

  //cout << "AMBA READ DATA: " << bus_state << endl;
  reset_hsel( );

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
      amba_write_data( );
      bus_state = AMBA_IDLE;
      break;

    case AMBA_READ_ADR:
      amba_read_address( );
      bus_state = AMBA_READ_DATA;
      break;

    case AMBA_READ_DATA:
      amba_read_data( );
      bus_state = AMBA_IDLE;
      break;

    default:
      break;
  } 
}
 
// Select slave device
void bus_amba::dev_select( ) {
  // Oh my oh why oh why you couldn't into memset oh my oh why
  for( int i = 0; i < DEVICE_COUNT; i++ ) hsel[i] = 0;

  sc_uint<20> dev_base = haddr.read( ) >> 12;

  //cout << "AMBA DEVSEL: addr: " << hex << haddr.read( ) << endl;
  //cout << "AMBA DEVSEL: base addr: " << hex << dev_base << endl;

  switch ( dev_base ) {
    case DEV1_BASE_ADDR_PREFIX:
      hsel[0] = 1;
      break;
    case DEV2_BASE_ADDR_PREFIX:
      hsel[1] = 1;
      break;
    case DEV3_BASE_ADDR_PREFIX:
      hsel[2] = 1;
      break;
    default:
      break;
  }
}


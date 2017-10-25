#include "test_spi.h"

void wait_fall( ) {
  wait( 40, SC_NS );
}

void test_spi::test_send( uint8_t in, uint8_t out, bool reset ) {

  data_in.write( in );

  rst.write( 1 );

  wait( );
  rst.write( 0 );
  wait( );
  
  start.write( 1 );

  wait( 20, SC_NS );

  start.write( 0 );

  msg = out;

  for( counter = 0; counter < 8; counter++ ) {
    if( counter >= 4 && reset ) {
      miso.write( 0 );
      rst.write( 1 );
      wait_fall( );
      rst.write( 0 );
      wait_fall( );
      break;
    } else {
      miso.write( msg << 7 & 0xFF );
      msg = msg >> 1;
      wait_fall( );
    }
  }

  wait( );
  wait( );

  // Reset data_out
  rst.write( 1 );
  wait( );
  rst.write( 0 );

  for ( int i = 0; i < 3; ++i ) {
    wait( );
  }

}

void test_spi::demo_send( ) {

  test_send( 0b00110101, 0b01010011, false );
  test_send( 0b10011001, 0b00001010, false );
  test_send( 0b10011001, 0b00001010, true );

  sc_stop( );
}


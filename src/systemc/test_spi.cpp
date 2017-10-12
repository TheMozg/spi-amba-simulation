#include "test_spi.h"

void test_spi::test_send( uint8_t in, uint8_t out, bool reset ) {

  data_in.write( in );

  rst.write( 1 );
  enable.write( 1 );

  wait( );
  rst.write( 0 );

  wait( );
  enable.write( 0 );

  msg = out;
  for( counter = 0; counter < 8; counter++ ) {
    if( counter == 4 && reset ) {
      rst.write( 1 );
      wait( );
      rst.write( 0 );
      wait( );
      break;
    }
    miso.write( msg & ( 1 << counter ) );
    wait( );
  }

  // Low on MISO and few dummy cycles just for pretty graph
  miso.write( 0 );
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

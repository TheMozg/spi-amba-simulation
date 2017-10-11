#include "test_spi.h"

void test_spi::demo_send( ) {

  data_in.write( 0b00110101 );

  rst.write( 1 );
  enable.write( 1 );

  wait( );
  rst.write( 0 );

  wait( );
  enable.write( 0 );

  msg = 0b01010011;
  for( counter = 0; counter < 8; counter++ ) {
    miso.write( msg & ( 1 << counter ) );
    wait( );
  }

  // Low on MISO and few dummy cycles just for pretty graph
  miso.write( 0 );

  for ( int i = 0; i < 3; ++i ) {
    wait( );
  }

  // Reset data_out
  rst.write( 1 );
  wait( );
  rst.write( 0 );

  for ( int i = 0; i < 3; ++i ) {
    wait( );
  }

  sc_stop( );
}


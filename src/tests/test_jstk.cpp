#include "test_jstk.h"

void test_jstk::test_send( uint8_t in ) {
  data_in_m.write( in );

  start.write( 1 );
  wait( );
  start.write( 0 );

  for( int i = 0; i < 40; i++ ) wait( );

}

void test_jstk::demo_send( ) {
  rst.write( 1 );
  wait( );
  rst.write( 0 );
  ss.write( 0 );

  // Cause PmodJSTK works in 5 bytes chunks
  test_send( 0b00000111 );
  test_send( 0b00000000 );
  test_send( 0b00000000 );
  test_send( 0b00000000 );
  test_send( 0b00000000 );

  sc_stop( );
}

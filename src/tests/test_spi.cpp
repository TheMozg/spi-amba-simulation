#include "test_spi.h"

void test_spi::test_send( uint8_t in, uint8_t out ) {
  data_in_m.write( in );
  data_in_s.write( out );

  start.write( 1 );
  wait( );
  start.write( 0 );

  for( int i = 0; i < 40; i++ ) wait( );

}

void test_spi::demo_send( ) {
  rst.write( 1 );
  wait( );
  rst.write( 0 );

  ss.write( 0 );
  test_send( 0b00110101, 0b01010011 );
  test_send( 0b10011001, 0b00001010 );
  ss.write( 1 );
  test_send( 0b11011001, 0b10001010 );
  sc_stop( );
}


#include "test_bus.h"

void test_bus::write( int address, int body ) {

  haddr.write( address );
  hwrite.write( 1 );
  wait( );
  hwrite.write( 0 );
  hwdata.write( body );
}

void test_bus::read( int address, int body, int dev ) {

  haddr.write( address );
  hwrite.write( 0 );
  wait( );
  hrdata_in[dev].write( body );
}

void test_bus::demo( ) {

  wait( );
  write( 0x40000ACC, 0xDEADBEEF );
  wait( );
  write( 0x40101CAD, 0xBEEFDEAD );
  wait( );
  write( 0x40000ACC, 0xBEDABABA );
  wait( );
  write( 0x40002ACC, 0xCBCC4013 );
  wait( );
  read( 0x40000ACC, 0xDEADBEEF, 0 );
  read( 0x40001ACC, 0xADBEEFAA, 1 );
  read( 0x40002ACC, 0xEADBEEFD, 2 );
  wait( );
  wait( );
  read( 0x40001ACC, 0xEADBEEED, 2 );
  wait( );
  hrdata_in[2].write( 0xDEADBEEF );
  hrdata_in[1].write( 0xDEADBEEF );
  wait( );
  wait( );
  wait( );
  write( 0x40000ACC, 0xDEADBEEF );
  write( 0x40101CAD, 0xBEEFDEAD );
  write( 0x40001ACC, 0x2ACC4013 );
  write( 0x40002ACC, 0x2BCC4013 );
  wait( );

  sc_stop( );
}

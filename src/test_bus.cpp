#include "test_bus.h"

void test_bus::write( int address, int body ) {

  haddr.write( address );
  hwrite.write( 1 );
  wait( );
  hwdata.write( body );
  wait( );
}

void test_bus::read( int address, int body ) {

  haddr.write( address );
  hwrite.write( 0 );
  wait( );
  hrdata.write( body );
  wait( );
}

void test_bus::demo( ) {

  wait( );
  write( 0x40000ACC, 0xDEADBEEF );
  write( 0x40001CAD, 0xBEEFDEAD );
 /* wait( );
  read( 0x40000ACC, 0xDEADBEEF );
  read( 0x40001ACC, 0xADBEEFAA );
  read( 0x40002ACC, 0xEADBEEFD );
 */ wait( );

  sc_stop( );
}


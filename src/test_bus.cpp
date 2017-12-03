#include "test_bus.h"

void test_bus::write( int address, int body ) {

  haddr.write( address );
  hwdata_buf.write( body );
  hwrite.write( 1 );
  wait( );
  wait( );
}

void test_bus::read( int address, int body ) {

  haddr.write( address );
  hrdata_buf.write( body );
  hwrite.write( 0 );
  wait( );
  wait( );
}

void test_bus::demo( ) {

  wait( );
  write( 0x40000ACC, 0xDEADBEEF );
  write( 0x50000CAD, 0xBEEFDEAD );
 // write( 0x51000CAD, 0x11111111 );
 // write( 0x60000BEE, 0x12345467 );
  wait( );
  read( 0x40000ACC, 0xDEADBEEF );
  read( 0x50000ACC, 0xADBEEFAA );
  read( 0x60000ACC, 0xEADBEEFD );

  sc_stop( );
}


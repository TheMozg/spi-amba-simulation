#include "test_spi_ahb.h"

void test_spi_ahb::write( int address, int body ) {

  haddr.write( address );
  hwrite.write( 1 );
  wait( );
  hwdata.write( body );
  wait( );
}

void test_spi_ahb::read( int address ) {

  haddr.write( address );
  hwrite.write( 0 );
  wait( );
  //hrdata.write( body );
  wait( );
}

void test_spi_ahb::demo( ) {

  wait( );
  write( 0x40000000, 0x1 );
  wait( );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
  read( 0x40000004 );
 // read( 0x40010004 );
 // read( 0x40000004 );
 // read( 0x40000008 );
 // read( 0x40000008 );
  wait( );

  sc_stop( );
}


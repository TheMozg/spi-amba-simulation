#include "test_spi_ahb.h"

void test_spi_ahb::write( int address, int body ) {

  haddr.write( address );
  hwrite.write( 1 );
  hsel.write( 1 );
  wait( );
  hsel.write( 0 );
  hwrite.write( 0 );
  hwdata.write( body );
  wait( );
}

void test_spi_ahb::read( int address ) {

  haddr.write( address );
  hwrite.write( 0 );
  hsel.write( 1 );
  wait( );
  hsel.write( 0 );
  //hrdata.write( body );
  wait( );
}

void test_spi_ahb::demo( ) {

  wait( );
  write( 0x40000004, 0x0 );
  wait( );
  read( 0x40000008 );
  write( 0x40000000, 0x111 );
  wait( );
  //write( 0x40000000, 0x111 );
  /*read( 0x40000008 );
  read( 0x40000008 );
  read( 0x40000008 );*/
 // read( 0x40010004 );
 // read( 0x40000004 );
 // read( 0x40000008 );
 // read( 0x40000008 );
  wait( );
  wait( );

  sc_stop( );
}


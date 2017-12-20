#include "test_din_dout.h"

void test_din_dout::write( int address, int body ) {

  haddr.write( address );
  hwrite.write( 1 );
  wait( );
  hwdata.write( body );
  wait( );
}

void test_din_dout::read( int address ) {

  haddr.write( address );
  hwrite.write( 0 );
  wait( );
  //hrdata.write( body );
  wait( );
}

void test_din_dout::demo( ) {

  wait( );
  write( 0x40000008, 0xDEADBFEF );
  wait( );
  switches.write( 0x0101 );
#ifdef DIN_DOUT_DEBUG
  printf("DINDOUT Switches new state: 0x%04X\n", (unsigned short) switches.read());
#endif
  read( 0x40000004 );
  switches.write( 0x0121 );
#ifdef DIN_DOUT_DEBUG
  printf("DINDOUT Switches new state: 0x%04X\n", (unsigned short) switches.read());
#endif
  read( 0x40010004 );
  switches.write( 0xBABA );
#ifdef DIN_DOUT_DEBUG
  printf("DINDOUT Switches new state: 0x%04X\n", (unsigned short) switches.read());
#endif
  read( 0x40000004 );
  read( 0x40000008 );
 // read( 0x40000008 );
  wait( );

  sc_stop( );
}


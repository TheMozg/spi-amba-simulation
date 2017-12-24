#include "system.h"

void main_sys::stimuli( ) {
  // Emulating user input
  while( 1 ) {
    switches.write( 0xBABA );
    wait( );
    wait( );
    switches.write( 0xDEAD );
    wait( );
    wait( );
    switches.write( 0xD00D );
    wait( );
    wait( );
    switches.write( 0xBEEF );
    wait( );
    wait( );
    switches.write( 0xD1C6 );
    wait( );
    wait( );
    switches.write( 0xB16B );
    wait( );
    wait( );
    switches.write( 0x00B5 );
    wait( );
    wait( );

  }
}


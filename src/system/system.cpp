#include "system.h"

void main_sys::stimuli( ) {
  // Emulating user input
  switches.write( 0xBABA );
  wait( );
  wait( );
  switches.write( 0xDEAD );
  wait( );
  wait( );
  switches.write( 0xBEDA );
  wait( );
  wait( );
}


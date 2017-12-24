#include "div_clk.h"

void div_clk::tick( ) {
  if( enable ) {
    divider++;
    if( divider == 2 ) {
      qclk.write( !qclk.read( ) );
      divider = 0;
    }
  } else {
    qclk.write( 0 );
    divider = 0;
  }
}


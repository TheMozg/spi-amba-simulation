#include "clock.h"

void clock_gen::tick( ) {
  hclk = !hclk;
  if( clock & hclk ) qclk.write( !qclk.read( ) );
}


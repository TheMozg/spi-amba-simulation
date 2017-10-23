// SPI, mode 0, only master mode, transieve from 0th bit to 7th

// Ports are assigned using write and local vars are assigned using `=` just for readability.
#include "spi.h"

// SPI receive
void spi::rx( ) {
  data_out.write( data_out.read( ) | ( miso.read( ) << (ctr.read( ) - 1) ) );
}

// SPI transmit
void spi::tx( ) {
  mosi.write( data_in.read( ) & ( 1 << ctr.read( ) ) );
}

// On reset end transaction end reset output data
void spi::reset( ) {
  end_transaction( );
  data_out.write( 0 ); 
}

/* On transaction end:
    MOSI -- Low
    SS -- High
    Busy -- Low

    Reset counter, disable toggler and set last bit flag to 0
*/
void spi::end_transaction( ) {
  ss.write( 1 );
  ctr.write( 0 );
  busy.write( 0 );

  mosi.write( 0 );

  toggle_start = 0;
  last = 0;
}

// Main SPI loop
void spi::loop( ) {

  toggle_start = toggle_start | ( start.read( ) & !busy.read( ) );

  if( rst ) {
    reset( );
    return;
  }

  // Main logic on every sclk tick
  if( sclk ) {
    if( toggle_start ) {
      rx( );

      busy.write( 1 );
      ss.write( 0 );
    } 

    if( last ) ss.write( 1 );

  } else if( busy ) {

    tx( );

    if( !last ) {
      ctr.write( ctr.read( ) + 1 );
    } else {
      end_transaction( );
    }

    if( ctr.read( ) == 7 ) last = 1;

  }

}


// SPI, mode 0, only master mode

#include "spi.h"

// SPI receive
void spi::rx( ) {
  data_out.write( data_out.read( ) | ( miso.read() << ctr.read( ) ) );
}

// SPI transmit
void spi::tx( ) {
  mosi.write( data_in.read( )[ ctr.read() ] );
}

void spi::transieve( ) {
  rx( ); tx( );
}

// On reset end transaction end reset output data
void spi::reset( ) {
  end_transaction( );
  data_out.write( 0 ); 
}

/* On transaction end:
    MOSI -- Low
    SS -- High
    Reset counter and enable toggler
*/
void spi::end_transaction( ) {
  ss.write( 1 );
  ctr.write( 0 );

  toggle_enable = 0;
  mosi.write( 0 );
}

// Main SPI loop
void spi::loop( ) {
  ss.write( 1 );
  ctr.write( 0 );

  // If it is the first bit, do not increase counter ctr
  bool first = 1;

  // Infinite loop because we are in a thread
  while( 1 ) {
    wait( );

    toggle_enable = toggle_enable | enable.read( );

    // On every sclk tick
    if( sclk ) {

      if( rst ) {
        reset( );
      } else if( toggle_enable ) {

        ss.write( 0 );
        transieve( );

        if( !first ) {
          ctr.write( ctr.read( ) + 1 );
        } else {
          first = 0;
        }
        
        if( ctr.read( ) == 7 ) end_transaction( );
      } 
    }

  }

}


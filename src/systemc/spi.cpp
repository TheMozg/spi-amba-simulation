// SPI, mode 0, only master mode, transieve from 0th bit to 7th

#include "spi.h"

// SPI receive
void spi::rx( ) {
  data_out.write( data_out.read( ) | ( miso.read( ) << ctr.read( ) - 1 ) );
  cout << "@" << sc_time_stamp( ) << " Receive miso/ctr: " << miso.read( ) << "/" << ctr.read( ) << endl;
  cout << "@" << sc_time_stamp( ) << " Data out at curr ctr " << data_out.read( )[ ctr.read( ) ] << endl;
}

// SPI transmit
void spi::tx( ) {
  mosi.write( data_in.read( ) & ( 1 << ctr.read( ) ) );
}

void spi::transieve( ) {
  tx( ); rx( );
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

  toggle_enable = 0;
  mosi.write( 0 );

  last = 0;
}

// Main SPI loop
void spi::loop( ) {
  
  // Cleanup before transaction
  end_transaction( );

  // Infinite loop because we are in a thread
  while( 1 ) {
    wait( );


    // On every sclk tick
    if( sclk ) {
      
      toggle_enable = toggle_enable | ( enable.read( ) & !busy.read( ) );

      if( rst ) {
        reset( );
      } else if( toggle_enable ) {
        busy.write( 1 );
        ss.write( 0 );

        transieve( );

        if( !last ) {
          ctr.write( ctr.read( ) + 1 );
        } else {
          end_transaction( );
        }

        if( ctr.read( ) == 7 ) last = 1;
      } 
    }

  }

}


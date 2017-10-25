// SPI, mode 0, only master mode, transieve from 0th bit to 7th

// Ports are assigned using write and local vars are assigned using `=` just for readability.
#include "spi.h"

// SPI receive
void spi::rx( ) {
  shiftreg[7] = miso.read( ); 
cout << "@" << sc_time_stamp( ) << " Receive miso/ctr: " << miso.read( ) << "/" << ctr << endl;
}

// SPI transmit
void spi::tx( ) {
  mosi.write( shiftreg[0] );
  shiftreg = shiftreg >> 1;
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
  ctr = 0;
  busy.write( 0 );

  mosi.write( 0 );

  trans_start = 0;
  last = 0;
  first = 1;
  shiftreg = 0;
}

// Main SPI loop
void spi::loop( ) {

  trans_start = trans_start | ( start.read( ) & !busy.read( ) );

  if( rst ) {
    reset( );
    return;
  }

  // Assign shiftreg to input packet
  if( first && sclk && trans_start ) {
    shiftreg = data_in.read( );
  }

  // Main logic on every sclk tick
  if( sclk ) {
    data_out.write( shiftreg );
    if( trans_start ) {
      if( first ) {
        busy.write( 1 );
        ss.write( 0 );
      }
      rx( );

    } 

  } else if( busy ) {

    tx( );

    if( !last && !first ) {
      ctr++;
    } else if( last ) {
      rx( );
      end_transaction( );
    }
    first = 0;

    if( ctr == 7 ) last = 1;

  }


}


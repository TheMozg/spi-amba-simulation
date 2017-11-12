// SPI, mode 0, only master mode, transieve from 0th bit to 7th

// Ports are assigned using write and local vars are assigned using `=` just for readability.
#include "spi.h"

// SPI receive
void spi::rx_capture( ) {
  reg_buf = miso.read( );
}

void spi::rx_write( ) {
  data_out.write( shift_reg );
}
// SPI transmit
void spi::tx( ) {
  mosi.write( shift_reg[0] );
  shift_reg = shift_reg >> 1;
  shift_reg[7] = reg_buf;
}

// On reset end transaction end reset output data
void spi::reset( ) {
  end_transaction( );
  data_out.write( 0 ); 
  
}

// End transaction routine
void spi::end_transaction( ) {
  ss.write( 1 );
  tr_ctr = 0;
  busy.write( 0 );
  mosi.write( 0 );

  fsm_state = STATE_IDLE;
}

// Main SPI loop
void spi::loop( ) {

  if( rst ) {
    reset( );
    return;
  }

  switch( fsm_state ) {
    
    case STATE_IDLE:
      if( start ) {
        busy.write( 1 );
        ss.write( 0 );

        shift_reg = data_in.read( );

        tx( );

        fsm_state = STATE_WAIT_SCLK_1;
      }
      break;

    case STATE_WAIT_SCLK_0:
      if( !sclk ) {

        tr_ctr++;

        tx( );

        rx_write( );
        
        fsm_state = ( tr_ctr == 8 ) ? STATE_FINAL : STATE_WAIT_SCLK_1;
      }
      break;

    case STATE_WAIT_SCLK_1:
      if( sclk ) {

        rx_capture( );

        fsm_state = STATE_WAIT_SCLK_0;
      }
      break;

    case STATE_FINAL:
    default:
      end_transaction( );
      break;
  } 

}


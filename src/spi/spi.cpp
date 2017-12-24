// SPI, mode 0, transieve from 0th bit to Nth

// Ports are assigned using write and local vars are assigned using `=` just for readability.
#include "spi.h"

// SPI receive
void spi_m::rx_capture( ) {
  reg_buf = miso.read( );
}

void spi_s::rx_capture( ) {
  reg_buf = mosi.read( );
}

void spi::rx_write( ) {
  data_out.write( shift_reg );
}

void spi::tx_shift( ) {
  shift_reg = shift_reg >> 1;
  shift_reg[SPI_BIT_CAP - 1] = reg_buf;
}

// SPI transmit
void spi_m::tx( ) {
  mosi.write( shift_reg[0] );
  tx_shift( );
}

void spi_s::tx( ) {
  miso.write( shift_reg[0] );
  tx_shift( );
}

void spi::reset( ) {
  tr_ctr = 0;
  busy.write( 0 );
  shift_reg = 0;
}

// End transaction routine
void spi_m::end_transaction( ) {
  reset( );

  mosi.write( 0 );
  //ss.write( 1 );
  fsm_state = SPI_IDLE;
}

void spi_s::end_transaction( ) {
  reset( );

  miso.write( 0 );
  fsm_state = SPI_IDLE;
}

void spi::fsm_wait_sclk_0( ) {
  tr_ctr++;
  tx( );
  rx_write( );
  fsm_state = ( tr_ctr == SPI_BIT_CAP ) ? SPI_FINAL : SPI_WAIT_SCLK_1;
}

void spi::fsm_wait_sclk_1( ) {
  rx_capture( );
  fsm_state = SPI_WAIT_SCLK_0;
}

void spi_m::fsm_wait_sclk_0( ) {
  if( !sclk ) {
    spi::fsm_wait_sclk_0( );
  }
}

void spi_m::fsm_wait_sclk_1( ) {
  if( sclk ) {
    spi::fsm_wait_sclk_1( );
  }
}

void spi_s::fsm_wait_sclk_0( ) {
  if( !sclk ) {
    spi::fsm_wait_sclk_0( );
  }
}

void spi_s::fsm_wait_sclk_1( ) {
  if( sclk ) {
    spi::fsm_wait_sclk_1( );
  }
}

void spi_m::fsm_idle( ) {
  if( start && !ss ) {
    data_out.write( 0 ); 
    busy.write( 1 );
    shift_reg = data_in.read( );
    tx( );
    fsm_state = SPI_WAIT_SCLK_1;
  }
}

void spi_s::fsm_idle( ) {
  // To set MISO before first master capture
  shift_reg = data_in.read( );
  miso.write( shift_reg[0] );

  if( !ss && sclk ) {
    data_out.write( 0 ); 
    busy.write( 1 );
    tx( );
    fsm_state = SPI_WAIT_SCLK_1;
  }
}

// Main SPI loop
void spi::loop( ) {
  if( rst ) {
    data_out.write( 0 ); 
    end_transaction( );
    return;
  }

  switch( fsm_state ) {
    
    case SPI_IDLE:
      fsm_idle( );
      break;

    case SPI_WAIT_SCLK_0:
      fsm_wait_sclk_0( );
      break;

    case SPI_WAIT_SCLK_1:
      fsm_wait_sclk_1( );
      break;

    case SPI_FINAL:
    default:
      end_transaction( );
      break;
  } 

}


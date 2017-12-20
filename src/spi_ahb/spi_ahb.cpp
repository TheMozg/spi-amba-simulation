#include "spi_ahb.h"

void spi_ahb::read( sc_uint<16> addr ) {
  sc_uint<32> data;

#ifdef SPI_AHB_DEBUG
  printf("SPI_AHB read: data: 0x%08X\n", (uint32_t) data );
#endif
  switch( addr ) {
    case SPI_AHB_READY:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request READY\n" );
#endif
      hrdata.write( ready );
      break;

    case SPI_AHB_X:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request X\n" );
#endif
      hrdata.write( x_data );
      break;
    
    case SPI_AHB_Y:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request Y\n" );
#endif
      hrdata.write( y_data );
      break;

    case SPI_AHB_BUTTONS:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request BUTTONS\n" );
#endif
      hrdata.write( buttons_data );
      break;
    
    default:
      data = 0;
      break;
  }
#ifdef SPI_AHB_DEBUG
#endif
}

void spi_ahb::wait_spi( ) {
  if( !busy ) {
    switch( ctr ) {
          
      case 0:
        ready = 0;
        x_data = data_out.read( );
        break;

      case 1:
        x_data |= data_out.read( ) << SPI_BIT_CAP;
        break;

      case 2:
        y_data = data_out.read( );
        break;

      case 3:
        y_data |= data_out.read( ) << SPI_BIT_CAP;
        break;

      case 4:
        buttons_data = data_out.read( );
        start.write( 0 );
        ctr = 0;
        fsm_state = SPI_AHB_IDLE;
        break;

      default:
        break;
      }
      ctr++;
  }
}



void spi_ahb::fsm( ) {
  if( hreset.read( ) ) {
    fsm_state = SPI_AHB_IDLE;
    ready = 1;
    x_data = 0;
    y_data = 0;
    buttons_data = 0;
    ctr = 0;
  }

  ready = ctr == 0 ? 1 : 0;

  switch( fsm_state ) {
    
    case SPI_AHB_IDLE:
      if( hsel ) {
#ifdef SPI_AHB_DEBUG
        printf("SPI_AHB fsm: quitting idle 0x%08X \n", (uint32_t) haddr.read( ) );
#endif
        buf_addr = haddr.read( );
        fsm_state = hwrite.read( ) ? SPI_AHB_WRITE : SPI_AHB_READ;
      } 
      break;

    case SPI_AHB_READ:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB fsm: READ 0x%08X\n", (uint32_t) buf_addr );
#endif
      read( ( sc_uint<16> ) buf_addr );
      fsm_state = SPI_AHB_IDLE;
      break;

    case SPI_AHB_WRITE: 
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB fsm: WRITE \n" );
#endif
      start.write( 1 );
      data_in.write( hwdata.read( ) );
      wait_spi( );
      fsm_state = SPI_AHB_IDLE; 
      break;

    default:
      break;
  }
  
  ready = ctr == 0 ? 1 : 0;
}


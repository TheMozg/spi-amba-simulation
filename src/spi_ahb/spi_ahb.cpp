#include "spi_ahb.h"

void spi_ahb::read( sc_uint<16> addr ) {
  sc_uint<32> data;

#ifdef SPI_AHB_DEBUG
  printf("SPI_AHB read: addr: 0x%08X\n", (unsigned short) addr );
#endif
  switch( addr ) {
    case SPI_AHB_READY:
      hrdata.write( ready );
      break;

    case SPI_AHB_X:
      hrdata.write( x_data );
      break;
    
    case SPI_AHB_Y:
      hrdata.write( y_data );
      break;

    case SPI_AHB_BUTTONS:
      hrdata.write( buttons_data );
      break;
    
    default:
      data = 0;
      break;
  }
#ifdef SPI_AHB_DEBUG
  printf("SPI_AHB read: data: 0x%08X\n", (uint32_t) data );
#endif
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

  ready = !( start.read( ) );

  switch( fsm_state ) {
    
    case SPI_AHB_IDLE:
      if( hsel ) {
       /* hwrite  ? execute_write( (sc_uint<16>) haddr.read( ) ) 
                : execute_read( (sc_uint<16>) haddr.read( ) ); 
        *///fsm_state = SPI_AHB_WAITING_END;
        buf_addr = haddr.read( );
        fsm_state = hwrite ? SPI_AHB_WRITE : SPI_AHB_READ;
      } 
      break;

    case SPI_AHB_READ:
      read( ( sc_uint<16> ) buf_addr );
      fsm_state = SPI_AHB_IDLE;
      break;

    case SPI_AHB_WRITE:
      start.write( 1 );
      fsm_state = SPI_AHB_WAITING_END; 
      break;

    case SPI_AHB_WAITING_END:
      if( !busy ) {
        switch( ctr ) {
          
          case 0:
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
      break;

    default:
      break;
  }
  ready = !( start.read( ) );

}


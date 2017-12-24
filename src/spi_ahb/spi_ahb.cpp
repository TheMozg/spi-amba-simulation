#include "spi_ahb.h"

void spi_ahb::read( sc_uint<12> addr ) {

  switch( addr ) {
    case SPI_AHB_READY:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request READY\n" );
#endif
      hrdata.write( ready );
      break;

    case SPI_AHB_SS:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request SS\n" );
#endif
      hrdata.write( ss.read( ) );
      break;
    
    case SPI_AHB_DATA:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request DATA\n" );
#endif
      hrdata.write( buf_data );
      break;

    case SPI_AHB_START:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request START\n" );
#endif
      hrdata.write( start.read( ) );
      break;
    
    default:
      buf_data = 0;
      break;
  }
}

void spi_ahb::write( sc_uint<12> addr ) {

  switch( addr ) {

    case SPI_AHB_SS:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request SS\n" );
#endif
      ss.write( hwdata.read( ) );
      break;
    
    case SPI_AHB_START:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request DATA\n" );
#endif
      buf_start = hwdata.read( ) & 0x1;
      break;

    default:
      break;
  }
}

void spi_ahb::fsm( ) {

  if( !n_hreset.read( ) ) {
    fsm_state = SPI_AHB_IDLE;
    ready = 1;
    buf_data = 0;
  }
  
  rst.write( !n_hreset.read( ) );
  ready = !busy.read( );
  
  switch( fsm_state ) {
    
    case SPI_AHB_IDLE:

      if( hsel ) {
        buf_addr = haddr.read( );
        fsm_state = hwrite.read( ) ? SPI_AHB_WRITE_START : SPI_AHB_READ;
      } 

      break;

    case SPI_AHB_READ:
      read( ( sc_uint<12> ) buf_addr );
      fsm_state = SPI_AHB_IDLE;
      break;

    case SPI_AHB_WRITE_START: 
      write( ( sc_uint<12> ) buf_addr );
      start.write( buf_start );

      if( buf_start ) {
        data_in.write( hwdata.read( ) );
      }

      fsm_state = SPI_AHB_WRITE_DONE; 
      break;

    case SPI_AHB_WRITE_DONE:
      if( buf_start ) {
        buf_start = 0;
      }
      start.write( buf_start );

      fsm_state = SPI_AHB_IDLE; 
      break;

    default:
      break;
  }
  
}


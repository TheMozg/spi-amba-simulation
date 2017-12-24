#include "spi_ahb.h"

void spi_ahb::read( sc_uint<12> addr ) {

  switch( addr ) {
    case SPI_AHB_READY:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request READY\n" );
#endif
      buf_rdata = ready;
      break;

    case SPI_AHB_SS:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request SS\n" );
#endif
      buf_rdata = ss.read( );
      break;
    
    case SPI_AHB_DATA:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request DATA\n" );
#endif
      buf_rdata = buf_data;
      break;

    case SPI_AHB_START:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB read: request START\n" );
#endif
      buf_rdata = start.read( );
      break;
    
    default:
      buf_data = 0;
      break;
  }
}

void spi_ahb::write( sc_uint<12> addr ) {

#ifdef SPI_AHB_DEBUG
  cout << hex << addr << endl;
#endif
  switch( addr ) {

    case SPI_AHB_SS:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB write: SS\n" );
#endif
      ss.write( buf_wdata & 0b1 );
      
      break;
    
    case SPI_AHB_START:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB write: START\n" );
#endif
      start.write( buf_wdata & 0b1 );
      break;
    
    case SPI_AHB_DATA:
#ifdef SPI_AHB_DEBUG
      printf("SPI_AHB write: DATA\n" );
#endif
      data_in.write( buf_wdata );

      break;

    default:
      break;
  }
}

void spi_ahb::fsm( ) {

  rst.write( !n_hreset.read( ) );
  ready = !busy.read( );

  if( !n_hreset.read( ) ) {
    fsm_state = SPI_AHB_IDLE;
    ready = 1;
    buf_data = 0;
    buf_wdata = 0;
    buf_rdata = 0;
    return;
  }

  if( ready ) buf_data = data_out.read( );

  if( start.read( ) ) start.write( 0 );
  
  switch( fsm_state ) {
    
    case SPI_AHB_IDLE:
      if( hsel ) {
        buf_addr = haddr.read( );
        fsm_state = hwrite.read( ) ? SPI_AHB_WRITE_START : SPI_AHB_READ_START;
      } 
      break;

    case SPI_AHB_READ_START:
      read( ( sc_uint<12> ) buf_addr );
      hrdata.write( buf_rdata );
      fsm_state = SPI_AHB_READ_DONE;
      break;

    case SPI_AHB_READ_DONE:
      fsm_state = SPI_AHB_IDLE; 
      break;

    case SPI_AHB_WRITE_START: 
      buf_wdata = hwdata.read( );
      fsm_state = SPI_AHB_WRITE_DONE; 
      break;

    case SPI_AHB_WRITE_DONE:
      write( ( sc_uint<12> ) buf_addr );
      fsm_state = SPI_AHB_IDLE; 
      break;

    default:
      break;
  }
  
}


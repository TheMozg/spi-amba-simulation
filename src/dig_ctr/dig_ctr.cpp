#include "dig_ctr.h"

void dig_ctr::byte_select( ) {

  switch( haddr.read( ) & 0x0000FFFF ) {
    case SEND_BYTE_ADDR:
      offset = SEND_OFFSET;
      break;

    case RECEIVE_BYTE_ADDR:
      offset = RECEIVE_OFFSET;
      break;
      
    case CTRL_BYTE_ADDR:
      offset = CTRL_OFFSET;
      break;
    
    default:
      error = 1;
      break;

  }

  fsm_state = CTR_ADDR;

}

/*void DinDout::user_input()
{
    switches = 0x7895;
    printf("Switches new state: 0x%04X\n", (unsigned short) switches);

    wait(100, SC_NS);

    switches = 0x55AA;
    printf("Switches new state: 0x%04X\n", (unsigned short) switches);

    wait(100, SC_NS);

    switches = 0x7744;
    printf("Switches new state: 0x%04X\n", (unsigned short) switches);
}*/

void dig_ctr::dump_control( ) {
  main_reg.write( main_reg.read( ) | start << START_BIT_OFFSET | 
                                     ready << READY_BIT_OFFSET |
                                     error << ERROR_BIT_OFFSET );
}

void dig_ctr::fsm( ) {
  
  if( hreset ) {
    offset = SEND_OFFSET;
    hrdata.write( 0 );
    main_reg.write( 0 );
    buf_addr = 0;
    fsm_state = CTR_IDLE;
  }

  dump_control( );

  switch( fsm_state ) {
    case CTR_IDLE:
      if( start ) {
        
        /*
            DO SMTHING HERE
        
        */
        start = 0;
      }
      ready = 1;
      break;

    case CTR_ADDR:
      status = hwrite.read( ) ? CTR_WRITE : CTR_READ;
      ready = 0;
      error = 0;
      buf_addr = haddr.read( );
      fsm_state = CTR_DATA;
      break;

    case CTR_DATA:
      if( (!hsel) & hclk ) {
        switch( status ) {

          case CTR_READ:
            if( buf_addr == RECEIVE_BYTE_ADDR ) {
              //hrdata.write( ctrl_wires.read( ) );
            } else if( buf_addr == CTRL_BYTE_ADDR ) {
              hrdata.write( main_reg.read( ) >> 16 & 0xF );
            } else error = 1;
            break;

          case CTR_WRITE:
            if( buf_addr == SEND_BYTE_ADDR ) {
              main_reg.write( hwdata.read( ) & 0xF );
            } else if( buf_addr == CTRL_BYTE_ADDR ) {
              if( hwdata.read( ) & 0x1 ) {
                //main_reg.write( main_reg.read( ) | ( 1 << START_BIT_OFFSET ) );
                start = 1;
              }
            } else error = 1;

            /*if( start ) {
              start = 0;
            }*/
            break;

          default:
            error = 1;
            break;
        }
        
        fsm_state = CTR_IDLE;
      }

    default:
      break;
  }

  dump_control( );

}


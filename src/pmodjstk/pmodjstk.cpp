#include <bitset>
#include "pmodjstk.h"

void pmodjstk::emul() {
  if( rst ) {
    fsm_state = JSTK_EMUL_WAIT_FIRST_BYTE;
    return;
  }

  switch( fsm_state ) {
    case JSTK_EMUL_WAIT_FIRST_BYTE:
      if( !ss ) {
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 1: setting value " << std::bitset<8>( x_1 ) << endl;
#endif
        data_in.write( x_1 );
        fsm_state = JSTK_EMUL_WAIT_FIRST_BYTE_END;
      }
      break;
    
    case JSTK_EMUL_WAIT_FIRST_BYTE_END:
      if( ss ) {
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 1: input value (leds) " << std::bitset<8>( data_out.read( ) ) << endl;
#endif
        fsm_state = JSTK_EMUL_WAIT_SECOND_BYTE;
      }
      break;

    case JSTK_EMUL_WAIT_SECOND_BYTE:
      if( !ss ) {
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 2: setting value " << std::bitset<8>( x_2 ) << endl;
#endif
        data_in.write( x_2 );
        fsm_state = JSTK_EMUL_WAIT_SECOND_BYTE_END;
      }
      break;

    case JSTK_EMUL_WAIT_SECOND_BYTE_END:
      if( ss ) {
        fsm_state = JSTK_EMUL_WAIT_THIRD_BYTE;
      }
      break;

    case JSTK_EMUL_WAIT_THIRD_BYTE:
      if( !ss ) {
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 3: setting value " << std::bitset<8>( y_1 ) << endl;
#endif
        data_in.write( y_1 );
        fsm_state = JSTK_EMUL_WAIT_THIRD_BYTE_END;
      }
      break;

    case JSTK_EMUL_WAIT_THIRD_BYTE_END:
      if( ss ) {
        fsm_state = JSTK_EMUL_WAIT_FOURTH_BYTE;
      }
      break;

    case JSTK_EMUL_WAIT_FOURTH_BYTE:
      if( !ss ) {
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 4: setting value " << std::bitset<8>( y_2 ) << endl;
#endif
        data_in.write( y_2 );
        fsm_state = JSTK_EMUL_WAIT_FOURTH_BYTE_END;
      }
      break;

    case JSTK_EMUL_WAIT_FOURTH_BYTE_END:
      if( ss ) {
        fsm_state = JSTK_EMUL_WAIT_FIFTH_BYTE;
      }
      break;

    case JSTK_EMUL_WAIT_FIFTH_BYTE:
      if( !ss ) {
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 5: setting value " << std::bitset<8>( buttons ) << endl;
#endif
        data_in.write( buttons );
        fsm_state = JSTK_EMUL_WAIT_FIFTH_BYTE_END;
      }
      break;

    case JSTK_EMUL_WAIT_FIFTH_BYTE_END:
      if( ss ) {
        fsm_state = JSTK_EMUL_WAIT_FIRST_BYTE;
      }
      break;

    default:
      break;
  }
}


#include <bitset>
#include "pmodjstk.h"

void pmodjstk::emul() {
  if( rst || ss ) {
    counter = 0;
    return;
  }
 
  switch( counter ) {
    case 0:
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 1: setting value " << std::bitset<8>( x_1 ) << endl;
#endif
        data_in.write( x_1 );
      break;

    case 8:
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 2: setting value " << std::bitset<8>( x_2 ) << endl;
#endif
        data_in.write( x_2 );
      break;

    case 16:
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 3: setting value " << std::bitset<8>( y_1 ) << endl;
#endif
        data_in.write( y_1 );
      break;

    case 24:
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 4: setting value " << std::bitset<8>( y_2 ) << endl;
#endif
        data_in.write( y_2 );
      break;

    case 32:
#ifdef PMODJSTK_DEBUG
        cout << "JSTK 5: setting value " << std::bitset<8>( buttons ) << endl;
#endif
        data_in.write( buttons );
      break;

    default:
      break;
  }
  counter = counter + 1;
}

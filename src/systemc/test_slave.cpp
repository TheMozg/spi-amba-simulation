#include "systemc.h"

SC_MODULE( test_slave ) {
  sc_out<bool> miso, rst, enable;
  sc_in<bool> mosi, clk, ss;
  sc_out<sc_uint<8> > data_in;

  void send( ) {

    wait( );
    rst.write( 1 );
    wait( );
    rst.write( 0 );

    wait( );
    data_in.write( 0b00110101 );
    enable.write( 1 );
  
    wait( );
    miso.write( 0 );

    enable.write( 0 );

    wait( );
    miso.write( 1 );

    wait( );
    miso.write( 0 );

    wait( );
    miso.write( 1 );

    wait( );
    miso.write( 0 );

    wait( );
    miso.write( 0 );


    wait( );
    miso.write( 1 );

    wait( );
    miso.write( 1 );

    wait( );

    for ( int i = 0; i < 3; ++i ) {
      wait( );
    }
    wait( );

    rst.write( 1 );

    wait( );

    rst.write( 0 );

    for ( int i = 0; i < 3; ++i ) {
      wait( );
    }

    sc_stop( );
  }

  SC_CTOR( test_slave ) {
    SC_THREAD( send );
    sensitive << clk.pos( );
  }

};


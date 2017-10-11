// SPI mode 0

#include "systemc.h"
#include "clock.cpp"

SC_MODULE( spi ) {
  sc_in<sc_uint<8> > data_in;
  sc_out<sc_uint<8> > data_out;

  // Counter for transieving
  sc_out<sc_uint<3> > ctr;

  sc_in<bool> clk, rst, enable, miso;
  sc_out<bool> sclk, ss, mosi;

  // SPI clock to generate sclk
  clock_gen clk_gen;

  uint8_t tmp;
  bool toggle_enable;

  void rx( ) {
    data_out.write( data_out.read( ) | ( miso.read() << ctr.read() - 1 ) );
  }

  void tx( ) {
    mosi.write( data_in.read( )[ ctr.read() ] );
  }

  void transieve( ) {
    tx( ); rx( );
  }

  void reset( ) {
    ss.write( 1 );
    ctr.write( 0 );
    tmp = 0;
    toggle_enable = 0;
    mosi.write( 0 );
  }

  void state( ) {
    ss.write( 1 );
    ctr.write( 0 );
    tmp = ctr.read( );

    bool last = 0;

    while( 1 ) {
      wait( );

      toggle_enable = toggle_enable | enable.read( );

      if( sclk ) {
        if( rst ) {
          reset( );
          data_out.write( 0 ); 
        } else if( last ) {
          transieve( );
          reset( );
          last = 0;
        } else if( toggle_enable ) {
          ss.write( 0 );

          transieve( );

          tmp = ctr.read( );
          if( !last ) {
            tmp++;
            ctr.write( tmp );
          }

          if( ctr.read() == 7 ) last = 1;
        } 
      }
    }
  }

  SC_CTOR( spi ):
    clk( "CLK" ), rst( "RST" ), enable( "ENABLE" ),
    miso( "MISO" ), sclk( "SCLK" ), ss( "SS" ), mosi( "MOSI" ),
    clk_gen( "CLK_GEN" ) {

    clk_gen.clock( clk );
    clk_gen.enable( enable );
    clk_gen.qclk( sclk );

    SC_THREAD( state );
    sensitive << sclk.pos();
    sensitive << rst.pos();
  };
};


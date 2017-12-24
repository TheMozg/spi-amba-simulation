#include "cpu.h"
#include "memmap.h"

// Non-pipeline io
uint32_t cpu::write( uint32_t address, uint32_t body ) {    
    
  haddr.write( address );    
  hwrite.write( 1 );    
  wait( );    
  hwrite.write( 0 );    
  hwdata.write( body );    
  wait( );    

#ifdef SW_OUTPUT
  printf( "CPU write: 0x%08X at 0x%08X\n", (uint32_t) hwdata.read( ), address );
#endif
  return hwdata.read( );
}    
    
uint32_t cpu::read( uint32_t address ) {    
    
  haddr.write( address );    
  hwrite.write( 0 );    
  wait( );    
  haddr.write( 0 );
  wait( );    
#ifdef SW_OUTPUT
  printf( "CPU read: 0x%08X at 0x%08X\n", (uint32_t) hrdata.read( ), address );
#endif
  return hrdata.read( );
}    

void cpu::sleep( uint32_t cycles ) {
  for( uint32_t i = 0; i < cycles; i++ ) wait( );
}

uint32_t cpu::grab_jstk_byte( ) {
  write( SA_ST, 0x1 ); // set start
  while( read( SA_RE ) != 1 );
  return read( SA_DA );
}

void cpu::set_leds( sc_uint<16> data ) {
  write( DD_OUT, data );
}

sc_uint<16> cpu::get_switches( ) {
  return (sc_uint<16>) read( DD_IN );
}

sc_uint<16> cpu::get_leds( ) {
  return (sc_uint<16>) read( DD_OUT );
}

void cpu::start_jstk_tr( sc_uint<16> data ) {
  write( SA_DA, data ); // set starting byte
  write( SA_SS, 0x0 ); // set ss
}  

void cpu::end_jstk_tr( ) {
  write( SA_SS, 0x1 ); // set ss
}

void cpu::software( ) {
  
  while( 1 ) {
    wait( );
    puts( "-- din_dout testing" );

    set_leds( 0xBABA );
    wait( );
    get_switches( );
    wait( );
    get_leds( );
    wait( );

    puts( "-- din_dout testing done" );

    sleep( 20 );

    puts( "-- periph contoller testing" );

    start_jstk_tr( 0x5 );
    for( int i = 0; i < 5; i++ ) grab_jstk_byte( );
    end_jstk_tr( );

    puts( "-- periph contoller testing done" );
    puts( "-- done" );

    sleep( 10 );
  }
  sc_stop( );
  
}


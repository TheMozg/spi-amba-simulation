#include "cpu.h"

uint32_t cpu::write( uint32_t address, uint32_t body ) {    
    
  haddr.write( address );    
  hwrite.write( 1 );    
  wait( );    
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
  wait( );    
#ifdef SW_OUTPUT
  printf( "CPU read: 0x%08X at 0x%08X\n", (uint32_t) hrdata.read( ), address );
#endif
  return hrdata.read( );
}    

void cpu::sleep( uint32_t cycles ) {
  for( uint32_t i = 0; i < cycles; i++ ) wait( );
}

void cpu::software( ) {

  while( 1 ) {
    puts( "-- din_dout testing" );

    write( 0x40000008, 0xDEADBEEF );
    write( 0x40000008, 0x0101BEDA );
    read( 0x40000004 );

    puts( "-- din_dout testing done" );

    puts( "-- periph contoller testing" );
    //read( 0x40001000 );
    write( 0x40001000, 1 );
    sleep( 5 );
    while( read( 0x40001000 ) );
    puts( "-- done" );
    //break;
  }

  sc_stop( );
  
}

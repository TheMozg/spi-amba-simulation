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
  printf( "CPU read: 0x%08X at 0x%08X\n", (uint32_t) hrdata[0].read( ), address );
#endif
  return hrdata[0].read( );
}    

void cpu::sleep( uint32_t cycles ) {
  for( uint32_t i = 0; i < cycles; i++ ) wait( );
}

void cpu::software( ) {

  puts( "-- din_dout testing" );

  write( 0x40000008, 0xDEADBEEF );
  write( 0x40000008, 0x0101BEDA );
  read( 0x40000004 );

  puts( "-- din_dout testing done" );

  while( 1 ) {
    puts( "-- periph contoller testing" );
    write( 0x40010000, 0x00000101 );
    while( !read( 0x40010004 ) );
    puts( "-- periph contoller testing done" );
    puts( "-- done" );
  }

  sc_stop( );
  
}

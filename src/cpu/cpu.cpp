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

uint32_t cpu::grab_jstk( ) {
  write( SA_ST, 0x1 ); // set start
  while( read( SA_RE ) != 1 );
  return read( SA_DA );
}

void cpu::software( ) {

  wait( );
  puts( "-- din_dout testing" );

  write( DD_OUT, 0x0101BEDA );
  wait( );
  read( DD_IN );
  wait( );
  read( DD_OUT );
  wait( );
  puts( "-- din_dout testing done" );

  sleep( 20 );

  puts( "-- periph contoller testing" );
  write( SA_DA, 0x5 ); // set starting byte
  write( SA_SS, 0x0 ); // set ss

  for( int i = 0; i < 5; i++ ) grab_jstk( );

  write( SA_SS, 0x1 ); // set ss
  wait( );

  puts( "-- periph contoller testing done" );
  puts( "-- done" );

  sleep( 10 );
  sc_stop( );
  
}


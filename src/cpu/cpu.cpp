#include "cpu.h"

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

void cpu::software( ) {

  wait( );
  puts( "-- din_dout testing" );

  write( 0x40000008, 0x0101BEDA );
  wait( );
  read( 0x40000004 );
  wait( );
  read( 0x40000008 );
  wait( );
  puts( "-- din_dout testing done" );

  sleep( 20 );

 // while( 1 ) {
    puts( "-- periph contoller testing" );
    write( 0x40001012, 0x5 ); // set starting byte
    write( 0x40001004, 0x0 ); // set ss

    write( 0x40001000, 0x1 ); // set start
    while( read( 0x40001008 ) != 1 );
    read( 0x40001012 );


    write( 0x40001000, 0x1 ); // set start
    while( read( 0x40001008 ) != 1 );
    read( 0x40001012 );

    write( 0x40001000, 0x1 ); // set start
    while( read( 0x40001008 ) != 1 );
    read( 0x40001012 );

    write( 0x40001000, 0x1 ); // set start
    while( read( 0x40001008 ) != 1 );
    read( 0x40001012 );

    write( 0x40001000, 0x1 ); // set start
    while( read( 0x40001008 ) != 1 );
    read( 0x40001012 );

    write( 0x40001004, 0x1 ); // set ss
    wait( );
    puts( "-- periph contoller testing done" );
    puts( "-- done" );
 //   break;
//  }

  sleep( 10 );
  sc_stop( );
  
}

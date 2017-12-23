/*
  Full system
  4000.... -- digital io
  4001.... -- periph device (pmodjstk)
*/
#pragma once

#include "systemc.h"
#include "bus_ahb.h"
#include "cpu.h"
#include "pmodjstk.h"
#include "spi_ahb.h"
#include "din_dout.h"

#define TRACE_FILE "system"

SC_MODULE( main_sys ) {

  // Master clock
  sc_clock* mclk; 

  // Master reset 
  sc_signal<bool> mrst { "mrst" };
  
  // Master AHB AMBA bus
  bus_ahb* mbus;
  
  // Peripheral AHB<->SPI controller
  spi_ahb* mspi_ahb;

  // Digital controller for leds and switches
  din_dout* mdin_dout;

  // Peripheral device
  pmodjstk* mjstk;

  // CPU
  cpu* mcpu;  

  // AMBA AHB bus ports
  sc_signal<bool> hclk                    { "hclk" };
  sc_signal<bool, SC_MANY_WRITERS> hwrite { "hwrite" };
  sc_signal<bool, SC_MANY_WRITERS> hsel[ dev_cnt ]; 
  sc_signal<bool> hreset;

  sc_signal<sc_uint<32>, SC_MANY_WRITERS> haddr  { "haddr" };
  sc_signal<sc_uint<32>, SC_MANY_WRITERS> hwdata { "hwdata" };
  sc_signal<sc_uint<32>, SC_MANY_WRITERS> hrdata[ AMBA_DEV_CNT ];

  // Leds and switches wires for digital io controller
  sc_signal<sc_uint<16> > switches  { "switches" }; 
  sc_signal<sc_uint<16> > leds      { "leds" }; 
  
  // Wires for periph controller
  sc_signal<bool> start { "start" },  spi_ahb_busy  { "spi_ahb_busy" };
  sc_signal<bool> miso  { "miso" },   mosi  { "mosi" };
  sc_signal<bool> sclk  { "sclk" },   ss    { "ss" };
  //sc_in<bool> rst;
  sc_signal<sc_uint<SPI_BIT_CAP> > spi_ahb_data_out { "spi_ahb_data_out" };
  sc_signal<sc_uint<SPI_BIT_CAP> > spi_ahb_data_in  { "spi_ahb_data_in" };

  sc_signal<sc_uint<SPI_BIT_CAP> > jstk_data_out { "jstk_data_out" };
  sc_signal<sc_uint<SPI_BIT_CAP> > jstk_data_in  { "jstk_data_in" };

  // PmodJSTK busy wire
  sc_signal<bool> jstk_busy { "jstk_busy" };

  void stimuli( ); 

  SC_CTOR( main_sys ) {
    
    // Master clock setup
    mclk = new sc_clock( "mclk", 10, SC_NS, 0.5, 10, SC_NS, true );

    // AMBA AHB bus setup
    mbus = new bus_ahb( "BUS_AHB" );
      mbus->hclk( *mclk );
      mbus->hwrite( hwrite );
      for( int i = 0; i < AMBA_DEV_CNT; i++ ) {
        mbus->hsel[i]( hsel[i] );
      }
      for( int i = 0; i < AMBA_DEV_CNT; i++ ) {
        mbus->hrdata[i]( hrdata[i] );
      }
      mbus->hreset( hreset );
      mbus->haddr( haddr );
      mbus->hwdata( hwdata );
      mbus->hreset( hreset );

    // CPU setup
    mcpu = new cpu( "CPU" );
      mcpu->hclk( *mclk );
      mcpu->haddr( haddr );
      mcpu->hwdata( hwdata );
      for( int i = 0; i < AMBA_DEV_CNT; i++ ) {
        mcpu->hrdata[i]( hrdata[i] );
      }
      mcpu->hwrite( hwrite );

    // Digital controller setup
    mdin_dout = new din_dout( "DIN_DOUT" );
      mdin_dout->hclk_i( *mclk );
      mdin_dout->hresetn_i( hreset );
      mdin_dout->haddr_bi( haddr );
      mdin_dout->hwdata_bi( hwdata );
      mdin_dout->hrdata_bo( hrdata[0] );
      mdin_dout->hwrite_i( hwrite );
      mdin_dout->hsel_i( hsel[0] );
      mdin_dout->switches( switches );
      mdin_dout->leds( leds );

    // Peripheral controller setup
    mspi_ahb = new spi_ahb( "SPI_AHB" );
      mspi_ahb->clk( *mclk );
      mspi_ahb->hwrite( hwrite );
      mspi_ahb->hwdata( hwdata );
      mspi_ahb->hrdata( hrdata[1] );
      mspi_ahb->haddr( haddr );
      mspi_ahb->hreset( hreset );
      mspi_ahb->hsel( hsel[1] );
      mspi_ahb->start( start );
      mspi_ahb->ss( ss );
      mspi_ahb->busy( spi_ahb_busy );
      mspi_ahb->sclk( sclk );
      mspi_ahb->miso( miso );
      mspi_ahb->mosi( mosi );
      mspi_ahb->data_in( spi_ahb_data_in );
      mspi_ahb->data_out( spi_ahb_data_out );
  
    // Peripheral device setup
    mjstk = new pmodjstk( "JSTK" );
      mjstk->clk( *mclk );
      mjstk->sclk( sclk );
      mjstk->mosi( mosi );
      mjstk->miso( miso );
      mjstk->rst( hreset );
      mjstk->ss( ss );
      mjstk->busy( jstk_busy );
      mjstk->data_out( jstk_data_out );
      mjstk->data_in( jstk_data_in );
    
    SC_THREAD( stimuli );
    sensitive << *mclk << mrst;
    
  }

};


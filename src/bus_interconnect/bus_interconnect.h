#pragma once

#include <systemc.h>

#define DEVICE_COUNT 3
#define BASE_ADDR_1 0x0450
#define BASE_ADDR_2 0x0454
#define BASE_ADDR_3 0x0458


SC_MODULE(bus_interconnect) {
  //define input and output ports
  sc_in<bool> hclk;
  sc_inout<bool> hwrite;
  sc_inout<sc_uint<32> > haddr;
  sc_inout<sc_uint<32> > hwdata;
  sc_out<sc_uint<32> > hrdata_out;

  sc_in<sc_uint<32> > hrdata_in[DEVICE_COUNT];
  sc_out<bool > hselect[DEVICE_COUNT];

  bool address_phase;
  bool write_transaction;
  bool read_transaction;

  sc_uint<16> previous_select;
  sc_uint<16> current_select;

  SC_CTOR(bus_interconnect) {
    previous_select = 0;
    current_select = 0;
    write_transaction = false;
    read_transaction = false;
    address_phase = true;

    SC_METHOD(bus_read);
    sensitive << hclk.neg();

    SC_METHOD(bus_write);
    sensitive << hclk.neg();

    SC_METHOD(device_select);
    sensitive << haddr;

    SC_METHOD(switch_phase);
    sensitive << hclk.pos();
  }

  void bus_read();
  void bus_write();
  void device_select();

  void switch_phase();
};


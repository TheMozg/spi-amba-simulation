#include "bus_interconnect.h"

void bus_interconnect::bus_read( ) {
  if (write_transaction) {
    return;
  }
  std::cout << "Phase " << address_phase << std::endl;
  read_transaction = read_transaction || !hwrite && address_phase;
  std::cout << "Read " << address_phase << std::endl;
  if (read_transaction) {
    if (!address_phase) {
      hrdata_out = hrdata_in[previous_select];
      read_transaction = false;
      previous_select = current_select;
    }
  }
}
 
void bus_interconnect::bus_write() {
  if (read_transaction) {
    return;
  }

  std::cout << "Write " << address_phase << std::endl;

  write_transaction = write_transaction || hwrite && address_phase;
}
 
void bus_interconnect::device_select() {
  previous_select = current_select;
  sc_uint<32> addr = haddr.read();
  switch (addr >> 16) {
    case BASE_ADDR_1:
      current_select = 0;
      break;
    case BASE_ADDR_2:
      current_select = 1;
      break;
    case BASE_ADDR_3:
      current_select = 2;
      break;
    default:
      current_select = DEVICE_COUNT + 1;
  }
//  current_select = addr >> 16;
  if (current_select < DEVICE_COUNT && current_select >= 0) {
    hselect[current_select].write(true);
  }
  if (previous_select < DEVICE_COUNT && previous_select >= 0) {
    hselect[previous_select].write(false);
  }
}
 
void bus_interconnect::switch_phase() {
  address_phase = !address_phase;
}


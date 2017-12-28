# ITMO SystemC & Verilog assignments
See branches and tags for assignments 1-3:

* `lab1` - SPI controller in SystemC and Verilog
* `lab2` - AMBA AHB controller in SystemC
* `lab3` - AMBA AHB controller in Verilog

# Assignment #2
AMBA AHB controller in SystemC

## Structure
* `bus_ahb`     -- peripheral AMBA AHB bus
* `spi`         -- SPI controller (master and slave, mode 0)
* `div_clk`     -- clock divider (for SPI)
* `pmodjstk`    -- PmodJSTK device emulation
* `dig_ctr`     -- digital controller for Nexys4 DDR leds and slide switches. (not_used, see din_dout)
* `periph_ctr`  -- peripheral controller (for PmodJSTK)
* `system`      -- main device
* `tests`       -- device tests
* `spi_ahb`     -- SPI-AHB controller

## Build
1. `make thirdparty` to build SystemC
2. `make` to build AMBA AHB controller and run testbench

## Output
Open `*.vcd` files in `build` directory with GTKWave

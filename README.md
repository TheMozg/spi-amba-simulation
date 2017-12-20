# SystemC / Verilog sandbox
`make thirdparty` to build SystemC and Icarus Verilog.

`make` to build spi.

# Warnings
* SPI on SystemC differs from SPI on Verilog

# Structure
* bus_ahb     -- peripheral AMBA AHB bus.
* spi         -- SPI controller (master and slave, mode 0).
* div_clk     -- clock divider (for SPI).
* pmodjstk    -- PmodJSTK device emulation.
* dig_ctr     -- digital controller for Nexys4 DDR leds and slide switches. (not_used, see din_dout)
* periph_ctr  -- peripheral controller (for PmodJSTK).
* system      -- main device.
* tests       -- device tests.


BUILD_DIR           :=  $(abspath build)

SYSTEMC_THD_SRC_DIR := thirdparty/systemc
SYSTEMC_THD_BLD_DIR := $(BUILD_DIR)/$(SYSTEMC_THD_SRC_DIR)-build
SYSTEMC_THD_INS_DIR := $(BUILD_DIR)/$(SYSTEMC_THD_SRC_DIR)-install

VERILOG_THD_SRC_DIR := thirdparty/verilog
VERILOG_THD_BLD_DIR := $(BUILD_DIR)/$(VERILOG_THD_SRC_DIR)-build
VERILOG_THD_INS_DIR := $(BUILD_DIR)/$(VERILOG_THD_SRC_DIR)-install

CXX                 := g++
CXXFLAGS            := -std=c++98 -g -Wall -Wextra -I$(SYSTEMC_THD_INS_DIR)/include -pthread

VERILOG             := $(VERILOG_THD_INS_DIR)/bin/vvp
CVERILOG            := $(VERILOG_THD_INS_DIR)/bin/iverilog
CVERILOGFLAGS       := -Wall

SYSTEMC_SRC_DIR     := src/systemc
SYSTEMC_SPI_EXE     := $(BUILD_DIR)/spi_systemc
SYSTEMC_SPI_VCD     := $(BUILD_DIR)/spi_systemc.vcd
SYSTEMC_SOURCES     := $(wildcard $(SYSTEMC_SRC_DIR)/*.cpp) $(SYSTEMC_THD_INS_DIR)/lib-linux64/libsystemc.a
SYSTEMC_HEADERS     := $(wildcard $(SYSTEMC_SRC_DIR)/*.h)

VERILOG_SRC_DIR     := src/verilog
VERILOG_SPI_EXE     := $(BUILD_DIR)/spi_verilog
VERILOG_SPI_VCD     := $(BUILD_DIR)/spi_verilog.vcd
VERILOG_SOURCES     := $(wildcard $(VERILOG_SRC_DIR)/*)


.PHONY: all
build: systemc verilog

.PHONY: systemc
systemc: $(SYSTEMC_SPI_VCD)

.PHONY: verilog
verilog: $(VERILOG_SPI_VCD)


$(SYSTEMC_SPI_VCD): $(SYSTEMC_SPI_EXE) $(MAKEFILE_LIST) | $(BUILD_DIR)
	cd $(BUILD_DIR) && $(SYSTEMC_SPI_EXE)

$(VERILOG_SPI_VCD): $(VERILOG_SPI_EXE) $(MAKEFILE_LIST) | $(BUILD_DIR)
	cd $(BUILD_DIR) && $(VERILOG_SPI_EXE)


$(SYSTEMC_SPI_EXE): $(SYSTEMC_SOURCES) $(SYSTEMC_HEADERS) $(MAKEFILE_LIST) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(SYSTEMC_SOURCES) -o $@ 

$(VERILOG_SPI_EXE): $(VERILOG_SOURCES) $(MAKEFILE_LIST) | $(BUILD_DIR)
	$(CVERILOG) $(CVERILOGFLAGS) $(VERILOG_SOURCES) -o $@ 


.PHONY: thirdparty
thirdparty: $(SYSTEMC_THD_SRC_DIR) $(VERILOG_THD_SRC_DIR)

.PHONY: $(SYSTEMC_THD_SRC_DIR)
$(SYSTEMC_THD_SRC_DIR): | $(SYSTEMC_THD_BLD_DIR)
	cd $(SYSTEMC_THD_BLD_DIR) && \
		$(abspath $(SYSTEMC_THD_SRC_DIR))/configure --prefix=$(SYSTEMC_THD_INS_DIR) CXXFLAGS="-DSC_DISABLE_COPYRIGHT_MESSAGE"
	make install -C $(SYSTEMC_THD_BLD_DIR) MAKEFLAGS=

.PHONY: $(VERILOG_THD_SRC_DIR)
$(VERILOG_THD_SRC_DIR): | $(VERILOG_THD_BLD_DIR)
	cd $(VERILOG_THD_SRC_DIR) && ./autoconf.sh
	cd $(VERILOG_THD_BLD_DIR) && \
		$(abspath $(VERILOG_THD_SRC_DIR))/configure --prefix=$(VERILOG_THD_INS_DIR)
	make install -C $(VERILOG_THD_BLD_DIR) MAKEFLAGS=


$(BUILD_DIR) $(SYSTEMC_THD_BLD_DIR) $(VERILOG_THD_BLD_DIR):
	mkdir -p $@


.PHONY: clean
clean:
	rm -rf $(SYSTEMC_SPI_EXE)
	rm -rf $(SYSTEMC_SPI_VCD)
	rm -rf $(VERILOG_SPI_EXE)
	rm -rf $(VERILOG_SPI_VCD)

.PHONY: clean/thirdparty
clean/thirdparty: clean/$(SYSTEMC_THD_SRC_DIR) clean/$(VERILOG_THD_SRC_DIR)

.PHONY: clean/$(SYSTEMC_THD_SRC_DIR)
clean/$(SYSTEMC_THD_SRC_DIR):
	rm -rf $(SYSTEMC_THD_BLD_DIR)
	rm -rf $(SYSTEMC_THD_INS_DIR)

.PHONY: clean/$(VERILOG_THD_SRC_DIR)
clean/$(VERILOG_THD_SRC_DIR):
	rm -rf $(VERILOG_THD_BLD_DIR)
	rm -rf $(VERILOG_THD_INS_DIR)

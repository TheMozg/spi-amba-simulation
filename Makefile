BUILD_DIR           :=  $(abspath build)

SYSTEMC_THD_SRC_DIR := thirdparty/systemc
SYSTEMC_THD_BLD_DIR := $(BUILD_DIR)/$(SYSTEMC_THD_SRC_DIR)-build
SYSTEMC_THD_INS_DIR := $(BUILD_DIR)/$(SYSTEMC_THD_SRC_DIR)-install

CXX                 := g++
CXXFLAGS            := -std=c++98 -g -Wall -Wextra -I$(SYSTEMC_THD_INS_DIR)/include -pthread

SYSTEMC_SRC_DIR     := src
SYSTEMC_SPI_EXE     := $(BUILD_DIR)/spi_systemc
SYSTEMC_SPI_VCD     := $(BUILD_DIR)/spi_systemc.vcd
SYSTEMC_SOURCES     := $(wildcard $(SYSTEMC_SRC_DIR)/*.cpp) $(SYSTEMC_THD_INS_DIR)/lib-linux64/libsystemc.a
SYSTEMC_HEADERS     := $(wildcard $(SYSTEMC_SRC_DIR)/*.h)

.PHONY: all
build: systemc

.PHONY: systemc
systemc: $(SYSTEMC_SPI_VCD)

$(SYSTEMC_SPI_VCD): $(SYSTEMC_SPI_EXE) $(MAKEFILE_LIST) | $(BUILD_DIR)
	cd $(BUILD_DIR) && $(SYSTEMC_SPI_EXE)

$(SYSTEMC_SPI_EXE): $(SYSTEMC_SOURCES) $(SYSTEMC_HEADERS) $(MAKEFILE_LIST) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(SYSTEMC_SOURCES) -o $@ 


.PHONY: thirdparty
thirdparty: $(SYSTEMC_THD_SRC_DIR)

.PHONY: $(SYSTEMC_THD_SRC_DIR)
$(SYSTEMC_THD_SRC_DIR): | $(SYSTEMC_THD_BLD_DIR)
	cd $(SYSTEMC_THD_BLD_DIR) && \
		$(abspath $(SYSTEMC_THD_SRC_DIR))/configure --prefix=$(SYSTEMC_THD_INS_DIR) CXXFLAGS="-DSC_DISABLE_COPYRIGHT_MESSAGE"
	make install -C $(SYSTEMC_THD_BLD_DIR) MAKEFLAGS=


$(BUILD_DIR) $(SYSTEMC_THD_BLD_DIR):
	mkdir -p $@


.PHONY: clean
clean:
	rm -rf $(SYSTEMC_SPI_EXE)
	rm -rf $(SYSTEMC_SPI_VCD)

.PHONY: clean/thirdparty
clean/thirdparty: clean/$(SYSTEMC_THD_SRC_DIR)

.PHONY: clean/$(SYSTEMC_THD_SRC_DIR)
clean/$(SYSTEMC_THD_SRC_DIR):
	rm -rf $(SYSTEMC_THD_BLD_DIR)
	rm -rf $(SYSTEMC_THD_INS_DIR)


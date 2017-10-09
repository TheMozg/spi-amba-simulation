BUILD_DIR :=  $(abspath build)
BUILD_SYSTEMC_DIR := $(abspath build_systemc)

SYSTEMC_TAR := systemc-2.3.1a.tar.gz
SYSTEMC_URL := http://www.accellera.org/images/downloads/standards/systemc/$(SYSTEMC_TAR)
SYSTEMC_DIR := $(BUILD_SYSTEMC_DIR)/install

CXX         := g++
CXXFLAGS    := -std=c++98 -g -Wall -Wextra -I$(SYSTEMC_DIR)/include -pthread
SRC_DIR     := src
TARGET      := $(BUILD_DIR)/hello
SOURCES     := $(wildcard $(SRC_DIR)/*.cpp) $(SYSTEMC_DIR)/lib-linux64/libsystemc.a
HEADERS     := $(wildcard $(SRC_DIR)/*.h)

.PHONY: all
all: build

.PHONY: build
build: $(TARGET)

$(TARGET): $(SOURCES) $(HEADERS) $(MAKEFILE_LIST) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $@ 

.PHONY: systemc
systemc: $(BUILD_SYSTEMC_DIR)/$(SYSTEMC_TAR)
	tar xzvf $< -C $(BUILD_SYSTEMC_DIR)
	cd $(BUILD_SYSTEMC_DIR)/systemc-2.3.1a && \
		./configure --prefix=$(abspath $(BUILD_SYSTEMC_DIR)/install) CXXFLAGS="-DSC_DISABLE_COPYRIGHT_MESSAGE"
	$(MAKE) install -C $(BUILD_SYSTEMC_DIR)/systemc-2.3.1a

$(BUILD_SYSTEMC_DIR)/$(SYSTEMC_TAR): | $(BUILD_SYSTEMC_DIR)
	wget $(SYSTEMC_URL) -O $@.tmp
	mv $@.tmp $@

$(BUILD_DIR) $(BUILD_SYSTEMC_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	rm *.vcd

.PHONY: clean-systemc
clean-systemc:
	rm -rf $(BUILD_SYSTEMC_DIR)

.PHONY: run
run: $(TARGET)
	$(TARGET)


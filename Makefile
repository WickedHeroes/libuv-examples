CC ?= $(which clang)

BUILDTYPE ?= Release
UV_DIR ?= deps/uv
UV_BUILD = $(UV_DIR)/out/$(BUILDTYPE)
UV_FLAGS = -fno-omit-frame-pointer

IDIR = $(UV_DIR)/include
CFLAGS = -pthread -fno-omit-frame-pointer -Wall -g

all:
	$(CC) $(CFLAGS) -o run main.c $(UV_BUILD)/libuv.a -I$(IDIR)

.PHONY: libuv.a clean

libuv.a:
	@if [ ! -d $(UV_DIR)/build/gyp ]; then \
		git clone https://git.chromium.org/external/gyp.git $(UV_DIR)/build/gyp; \
	fi
	@cd $(UV_DIR); \
		./gyp_uv.py -f make > /dev/null; \
		BUILDTYPE=$(BUILDTYPE) CFLAGS=$(UV_FLAGS) make -C out -j8

clean:
	@rm -fv ./run
	@rm -frv $(UV_DIR)/out
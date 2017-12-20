TARGET = build/vex
LIBS = -lm
DEPS = thirdparty/libuv/build/Release/libuv.a
CC = gcc
CFLAGS = -g -Wall -I include -I thirdparty/libuv/include

.PHONY: default all checkdir clean deps

default: checkdir $(TARGET)
all: clean default

OBJECTS = $(subst src/,build/,$(subst .c,.o, $(wildcard src/*.c)))
HEADERS = $(wildcard include/*.h)

build/%.o: src/%.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) -Wall $(OBJECTS) $(DEPS) $(LIBS) -o $@

deps:
	git submodule init && git submodule update

build_deps: deps libuv.a

libuv.a:
	cd thirdparty/libuv && ./gyp_uv.py -f xcode
	cd thirdparty/libuv && xcodebuild -ARCHS="x86_64" -project uv.xcodeproj -configuration Release -target All

checkdir:
	@mkdir -p build

clean:
	@rm -rf build/
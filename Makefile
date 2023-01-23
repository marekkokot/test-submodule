all: main run

CC 	= g++
CFLAGS	= -fPIC -Wall -O3 -m64 -std=c++17 -mavx -pthread -fpermissive
CLINK	= -lm -std=c++17 -lpthread -static-libstdc++ -lgfortran

release: CLINK	= -lm -std=c++17 -static -lgfortran -lquadmath -Wl,--whole-archive -lpthread -Wl,--no-whole-archive
release: all

%.o: %.cpp 
	$(CC) $(CFLAGS) -I ext-lib/mimalloc/include -c $< -o $@

main: src/main

ext-lib/mimalloc/build/CMakeFiles/mimalloc-obj.dir/src/static.c.o:
	mkdir -p ext-lib/mimalloc/build
	cd ext-lib/mimalloc/build; \
	cmake ..; \
	make

src/main: src/main.o ext-lib/mimalloc/build/CMakeFiles/mimalloc-obj.dir/src/static.c.o
	$(CC) -o $@  src/main.o ext-lib/mimalloc/build/CMakeFiles/mimalloc-obj.dir/src/static.c.o $(CLINK)

run: src/main
	MIMALLOC_SHOW_STATS=1 src/main

clean:
	rm src/*.o
	rm src/main
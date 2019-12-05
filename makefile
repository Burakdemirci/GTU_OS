CC=g++ -std=c++11
CFLAGS=-I.
DEPS = gtuos.h memory.h 8080emuCPP.h memoryBase.h gtuos.cpp 8080emu.cpp memory.cpp
OBJ = emulator.o


buildemulator:
	$(CC)  main.cpp $(DEPS) -w -o emulator.out $(CFLAGS) 


# Makefile

# Compiler
CC = LD_LIBRARY_PATH=./bin ./bin/stampbc

# Default target
all: help

# Help target
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make compile file=<file>         Compile the specified file"

# Compile target
compile:
	$(CC) -v -o ./out/$(file).bin -c $(file).BS2
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
	@echo "\n\nSTEP 2 Compiling $(file).BSP..."
	$(CC) -v -o ./out/$(file).bin -c $(file).BSP
run:
	@crystal run main.cr
start:
	@./main
target:
	@echo "Building for: Linux x86_64"
	crystal build main.cr --cross-compile
	cc main.o -o main  -rdynamic -L/usr/bin/../lib/crystal -lpcre2-8  -lm -lgc -lpthread -ldl  -lpthread -levent  -lrt -lpthread -ldl
clean:
	@echo "Executing cleanup..."
	rm -rf main.o
	rm -rf main
	rm -rf IZEBOT.BSP
	rm -rf out/IZEBOT.bin

# Dummy targets for demo purposes
time: 
	@make target
life: 
	@make start
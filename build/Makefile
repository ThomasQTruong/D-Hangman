# By Thomas Truong
# Quickly compiles and links every .d file in the
# src folder, and places them into the bin folder.

# Directory paths.
SRC = ../src/
BIN = ../bin/

# Every object file needed for linking.
OBJECTS = hangman.o
# The path of every object file.
PATHS = $(foreach path, $(OBJECTS), $(BIN)$(path))

# Function names to run.
all: hangman

# Functions.
hangman: $(PATHS)
	gdc -o $(BIN)$@ $^

# Compile .d files to .o files.
$(BIN)%.o: $(SRC)%.d
	gdc -c -o $@ $<

# make run.
run:
	make clean
	make
	$(BIN)hangman

# make clean.
clean:
	rm -f $(BIN)*

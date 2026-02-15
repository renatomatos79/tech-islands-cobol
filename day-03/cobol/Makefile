# ---------------------------------------------------------
# VARIABLES (so we don't repeat ourselves later)
# ---------------------------------------------------------

# Name of the COBOL compiler command
COBC = cobc

# Folder where our app source files live
SRC = src

# Folder where compiled binaries will be placed
BIN = bin


# ---------------------------------------------------------
# DEFAULT TARGET
# ---------------------------------------------------------
# When we just type:  make
# this is the target that will run automatically
# It says: "build the file bin/app"
# ---------------------------------------------------------
all: $(BIN)/app


# ---------------------------------------------------------
# HOW TO BUILD bin/app
# ---------------------------------------------------------
# This is the actual compilation rule.
# It says:
#   To create bin/app, do the following steps:
# ---------------------------------------------------------
$(BIN)/app:
	# Ensure the output folder exists
	mkdir -p $(BIN)

	# Compile the COBOL programs into one executable:
	# -x          = create an executable program
	# -o bin/app  = name of the output file
	# Then we list all COBOL source files to compile together
	$(COBC) -x -o $(BIN)/app \
		$(SRC)/main.cob \
		$(SRC)/modules/math_utils.cob \
		$(SRC)/modules/is_number.cob \
		$(SRC)/modules/read_number.cob

# ---------------------------------------------------------
# RUN THE PROGRAM
# ---------------------------------------------------------
# When we type:  make run
# it will:
# 1) First run "make all" (compile if needed)
# 2) Then execute the program
# ---------------------------------------------------------
run: all
	./$(BIN)/app


# ---------------------------------------------------------
# CLEAN TARGET
# ---------------------------------------------------------
# When we type:  make clean
# it deletes all compiled files in bin/
# Useful when we want a fresh rebuild
# ---------------------------------------------------------
clean:
	rm -rf $(BIN)/*

# ---------------------------------------------------------
# CLEAN + RUN IN ONE COMMAND
# ---------------------------------------------------------
# When you type:  make crun
# it will:
# 1) run "make clean"
# 2) then run "make run"
# ---------------------------------------------------------
crun: clean run

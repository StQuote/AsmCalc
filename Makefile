SRC=main.s print.s strlen.s
OUT=acalc
FLAGS=-nostdlib -Wl,--build-id=none -o $(OUT) $(SRC)

.PHONY: all clean

all: $(OUT)

clean:
	rm $(OUT)

$(OUT) : $(SRC)
	gcc $(FLAGS)

debug: FLAGS+=-g
debug: $(OUT)


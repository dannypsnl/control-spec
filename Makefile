.PHONY: all install doc clean run runAll

all:
	@idris2 --build

install:
	@idris2 --install

doc:
	@idris2 --mkdoc

clean:
	@idris2 --clean

run: all
	@./build/exec/spec-discover test

runAll: all
	@make -C test

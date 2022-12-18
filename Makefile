.PHONY: all install doc clean run runAll

all:
	@idris2 --build ./control-spec.ipkg

install:
	@idris2 --install ./control-spec.ipkg

doc:
	@idris2 --mkdoc ./control-spec.ipkg

clean:
	@idris2 --clean ./control-spec.ipkg

run: all
	@./build/exec/spec-discover test

runAll: all
	@make -C test

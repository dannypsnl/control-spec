.PHONY: all install test doc clean

all:
	@idris2 --build ./iunit.ipkg

install:
	@idris2 --install ./iunit.ipkg

test:
	@idris2 --build ./test/test.ipkg

doc:
	@idris2 --mkdoc ./iunit.ipkg

clean:
	@idris2 --clean ./iunit.ipkg

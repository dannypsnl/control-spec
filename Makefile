.PHONY: all install doc clean

all:
	@idris2 --build ./package.ipkg

install:
	@idris2 --install ./package.ipkg

doc:
	@idris2 --mkdoc ./package.ipkg

clean:
	@idris2 --clean ./package.ipkg

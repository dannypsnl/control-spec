.PHONY: all install clean

all:
	@idris2 --build ./package.ipkg

install:
	@idris2 --install ./package.ipkg

clean:
	@idris2 --clean ./package.ipkg

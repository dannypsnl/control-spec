{
  description = "unit test framework for idris2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    idris-lang.url = "github:idris-lang/Idris2";
    idris-lang.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, idris-lang }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        stdenv = pkgs.stdenv;

        idris2 = idris-lang.packages.${system}.idris2;
        rlwrap = pkgs.rlwrap;

        control-spec = stdenv.mkDerivation {
          name = "control-spec";
          version = "0.1.0";
          src = ./.;

          buildInputs = [ idris2 ];
          buildPhase = ''
            idris2 --build
          '';
          installPhase = ''
            IDRIS2_PREFIX=$out idris2 --install
            mkdir -p $out/bin
            mv ./build/exec/* $out/bin/
          '';
        };
      in rec {
        packages = { control-spec = control-spec; };
        packages.default = packages.control-spec;
        devShells.default = pkgs.mkShell {
          buildInputs = [ idris2 rlwrap control-spec ];
        };
      }
    );
}

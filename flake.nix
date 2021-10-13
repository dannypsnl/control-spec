{
  description = "idris-unit";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.idris = {
    url = "github:idris-lang/Idris2";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };
  outputs = { self, nixpkgs, idris, flake-utils}: flake-utils.lib.eachDefaultSystem (system:
    let
      npkgs = import nixpkgs { inherit system; };
      ipkgs = idris.packages.${system};
      pkgs = idris.buildIdris.${system} {
        projectName = "idris-unit";
        src = ./src;
        idrisLibraries = [];
      };
    in rec {
      packages = pkgs // ipkgs;
      defaultPackage = pkgs.build;
      devShell = npkgs.mkShell {
        buildInputs = [ ipkgs.idris2 ];
      };
    }
  );
}

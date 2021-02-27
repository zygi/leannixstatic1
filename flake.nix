{
  description = "TODO";

  inputs.lean.url = github:zygi/lean4;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, lean, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        cPkg = with import nixpkgs { inherit system; };
          stdenv.mkDerivation rec {
            buildInputs = [glibc.static lean.packages.${system}.leanc];
            name = "NativeCHelpers";
            src = ./native_code.c;
            dontUnpack = true;
            # note that using leanc means the includes will be properly added
            # note 2: using -fPIC because the lib's consumers will use it to
            # build a plugin (shared lib).
            buildPhase =
              "leanc -fPIC -c -o out.o ${src}; ar rcs lib${name}.a *.o";
            installPhase = "mkdir -p $out; install -t $out lib${name}.a";
          };

        leanPkgs = lean.packages.${system};
        pkg = leanPkgs.buildLeanPackage {
          name = "LeanNixStatic1";
          src = ./.;
          # Each derivation here should contain a static library in 
          # `${deriv}/lib${static.name}.a`. 
          staticLibDeps = [ cPkg ];
        };
      in {
        packages = pkg // {
          inherit (leanPkgs) lean;
          inherit cPkg;
        };

        defaultPackage = pkg.modRoot;
      }
  );
}


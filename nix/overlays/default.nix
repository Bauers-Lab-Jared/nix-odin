{lib}: (
  final: prev: {
    buildOdin = import ../buildOdin.nix {pkgs = final;};

    odinLibs = lib.packagesFromDirectoryRecursive {
      inherit (prev) callPackage;
      directory = ../odinLibs;
    };

    # TODO: Wait for https://github.com/odin-lang/Odin/pull/4619 to be merged
    odin = prev.odin.overrideAttrs {
      patches = [
        ./odin.patch
      ];
    };

    # TODO: Wait for https://github.com/NixOS/nixpkgs/pull/357729 to be merged
    raylib = final.callPackage ./raylib.nix {};
  }
)

{lib}: (
  final: prev: {
    odinLibs = lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ../odinLibs;
    };

    odinConfig = configModules: let
      pkgs = final;
      modules =
        [
          ({...}: {config._module.args = {inherit pkgs;};})
          ../modules
        ]
        ++ configModules;
    in
      (lib.evalModules {inherit modules;}).config;

    buildOdin = import ../buildOdin.nix {pkgs = final;};

    # TODO: Wait for https://github.com/odin-lang/Odin/pull/4619 to be merged
    odin = prev.odin.overrideAttrs {
      patches = [
        ./odin.patch
      ];
    };

    # TODO: Wait for https://github.com/NixOS/nixpkgs/pull/357729 to be merged
    raylib = final.callPackage ./raylib.nix {};

    sokol-odin = import ./sokol {
      inherit lib prev final;
    };
  }
)

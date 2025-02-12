{lib}: (
  final: prev: let
    odinLibs = lib.packagesFromDirectoryRecursive {
      inherit (prev) callPackage;
      directory = ../odinLibs;
    };
  in {
    inherit odinLibs;

    odinConfig = configModules: let
      pkgs = final;
      modules =
        [
          ({...}: {config._module.args = {inherit pkgs odinLibs;};})
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
  }
)

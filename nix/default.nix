{
  lib,
  pkgs,
  ...
}: {
  export = {
    lib = configModules: let
      inherit (lib.evalModules {modules = [./modules] ++ configModules;}) odinConfig;
    in {
      inherit odinConfig;
      buildOdin = import ./buildOdin.nix {inherit odinConfig;};
    };
    odin-libs = lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      directory = ./odin-libs;
    };
  };
}

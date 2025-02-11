{
  lib,
  pkgs,
  ...
}: {
  export = let
    odinLibs = lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      directory = ./odinLibs;
    };
  in {
    lib = configModules: let
      odinConfig = let
        modules =
          [
            ({...}: {config._module.args = {inherit pkgs odinLibs;};})
            ./modules
          ]
          ++ configModules;
      in
        (lib.evalModules {inherit modules;}).config;
    in {
      inherit odinConfig;
      buildOdin = import ./buildOdin.nix {inherit odinConfig;};
    };
    inherit odinLibs;
  };
}

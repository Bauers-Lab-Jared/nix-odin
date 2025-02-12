{
  lib,
  appliedOverlay,
  ...
}: {
  export = let
    pkgs = appliedOverlay;
    inherit (pkgs) odinLibs;
    odinConfig = configModules: let
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
    packages = {inherit odinLibs;};
  };
}

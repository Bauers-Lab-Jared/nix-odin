{
  lib,
  config,
  pkgs,
  odinLibs,
  ...
}: let
  cfg = config.libs;
  inherit (lib) types;
in {
  options = {
    libs = {
      import = lib.mkOption {
        type = types.listOf types.str;
        default = [];
      };
      odinLib = lib.mkOption {
        type = types.nullOr types.package;
      };
    };
  };

  config = lib.mkIf (cfg.import != []) {
    libs.odinLib = let
      links =
        map (name: {
          inherit name;
          path = odinLibs.${name};
        })
        cfg.import;
    in
      pkgs.linkFarm "odinLib" links;

    cli.all.args = ["-collection:lib='${cfg.odinLib}'"];
  };
}

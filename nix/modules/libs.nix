{
  lib,
  config,
  pkgs,
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
        type = types.anything;
        default = [];
      };
    };
  };

  config = lib.mkIf (cfg.import != []) {
    libs.odinLib = let
      links =
        map (
          s: let
            p = lib.splitString "." s;
          in {
            name = builtins.concatStringsSep "/" p;
            path = "${lib.getAttrFromPath p pkgs.odinLibs}/include";
          }
        )
        cfg.import;
    in
      pkgs.linkFarm "odinLib" links;

    cli.all.args = ["-collection:lib='${cfg.odinLib}'"];
  };
}

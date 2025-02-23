{
  lib,
  config,
  ...
}: let
  cfg = config.sokol;
  inherit (lib) types;
in {
  options.sokol = {
    enable = lib.mkEnableOption "Add sokol to the project";
    modules = lib.mkOption {
      type = types.listOf (types.enum [
        "log"
        "gfx"
        "app"
        "glue"
        "time"
        "audio"
        "debugtext"
        "shape"
        "gl"
      ]);
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    buildInputStrs = map (moduleName: "odinLibs.sokol.${moduleName}") cfg.modules;
    libs.import = map (moduleName: "sokol.${moduleName}") cfg.modules;
  };
}

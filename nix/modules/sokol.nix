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
    slang = lib.mkOption {
      type = types.listOf (types.enum [
        "glsl410"
        "glsl430"
        "glsl300es"
        "hlsl4"
        "hlsl5"
        "metal_macos"
        "metal_ios"
        "metal_sim"
        "wgsl"
      ]);
      default = ["glsl430"];
    };
  };

  config = lib.mkIf cfg.enable {
    nativeBuildInputStrs = ["sokol-shdc"];
    extraEnvVars.SLANG = builtins.concatStringsSep ":" (lib.unique cfg.slang);
    buildInputStrs = map (moduleName: "odinLibs.sokol.${moduleName}") cfg.modules;
    libs.import = map (moduleName: "sokol.${moduleName}") cfg.modules;
  };
}

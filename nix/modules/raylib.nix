{
  lib,
  config,
  ...
}: let
  cfg = config.raylib;
in {
  options.raylib = {
    enable = lib.mkEnableOption "Add raylib to the project";
  };

  config = lib.mkIf cfg.enable {
    buildInputs = [
      "libX11"
      "libGL"
      "raylib"
    ];

    cli.all.args = ["-define:RAYLIB_SYSTEM=true"];
  };
}

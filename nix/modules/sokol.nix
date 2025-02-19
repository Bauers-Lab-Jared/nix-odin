{
  lib,
  config,
  ...
}: let
  cfg = config.sokol;
in {
  options.sokol = {
    enable = lib.mkEnableOption "Add sokol to the project";
  };

  config = lib.mkIf cfg.enable {
    buildInputStrs = [
      "odinLibs.sokol"
      "libGLU"
      "mesa"
      "xorg.libX11"
      "xorg.libXi"
      "xorg.libXcursor"
      "alsa-lib"
    ];
    libs.import = ["sokol"];
  };
}

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
    buildInputs = [
    ];
    libs.import = ["sokol"];
  };
}

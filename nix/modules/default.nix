{lib, ...}: let
  inherit (lib) types;
in {
  imports = [
    ./cli.nix
    ./raylib.nix
    ./libs.nix
  ];
  options = {
    nativeBuildInputs = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    buildInputs = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = {
  };
}

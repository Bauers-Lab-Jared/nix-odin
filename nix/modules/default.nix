{lib, ...}: let
  inherit (lib) types;
in {
  imports = [
    ./cli.nix
    ./raylib.nix
    ./libs.nix
    ./sokol.nix
  ];
  options = let
    mkOpt = type: lib.mkOption {inherit type;};
  in {
    nativeBuildInputStrs = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    buildInputStrs = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    pname = mkOpt types.str;
    version = mkOpt types.str;
    src = mkOpt types.path;
  };

  config = {
    nativeBuildInputStrs = [
      "gdb"
      "go-task"
      "odin"
    ];
  };
}

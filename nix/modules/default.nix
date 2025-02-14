{lib, ...}: let
  inherit (lib) types;
in {
  imports = [
    ./cli.nix
    ./raylib.nix
    ./libs.nix
  ];
  options = let
    mkOpt = type: lib.mkOption {inherit type;};
  in {
    nativeBuildInputs = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    buildInputs = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    pname = mkOpt types.str;
    version = mkOpt types.str;
    src = mkOpt types.path;
  };

  config = {
    nativeBuildInputs = [
      "gdb"
      "go-task"
      "odin"
    ];
  };
}

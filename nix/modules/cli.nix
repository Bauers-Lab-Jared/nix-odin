{
  lib,
  config,
  ...
}: let
  cfg = config.cli;
  inherit (lib) types;
in {
  options.cli = let
    mkLinesOpt = lib.mkOption {
      type = types.listOf types.str;
    };
    CmdType = types.submodule {
      options = {
        args = mkLinesOpt;
        cmd = lib.mkOption {
          type = types.str;
        };
      };
    };
  in
    {
      all.args = mkLinesOpt;
    }
    // (lib.genAttrs ["build" "test" "debug"] (name: lib.mkOption {type = CmdType;}));

  config.cli = let
    baseCmd = type: "odin ${
      if type == "test"
      then "test"
      else "build"
    } $src";
  in
    lib.mkMerge [
      {
        all.args = [
          "-use-separate-modules"
        ];
        build.args = [
          "-out:$out/bin/$pname"
          "-warnings-as-errors"
          "-build-mode:exe"
        ];
        test.args = [
          "-out:test/main"
          "-o:none"
          "-all-packages"
        ];
        debug.args = [
          "-out:debug/main"
          "-o:none"
          "-debug"
          "-build-mode:exe"
        ];
      }
      (lib.genAttrs ["build" "test" "debug"] (name: {
        cmd = builtins.concatStringsSep " " ([
            (baseCmd name)
          ]
          ++ cfg.all.args
          ++ cfg.${name}.args);
      }))
    ];
}

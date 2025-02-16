{
  lib,
  prev,
  final,
  ...
}: let
  mkSokolLib = import ./mkSokolLib.nix;
  sokol-odin-src = prev.callPackage ./sokol-odin.nix {};
  sokolModules = [
    "log"
    "gfx"
    "app"
    "glue"
    "time"
    "audio"
    "debugtext"
    "shape"
    "gl"
  ];
in
  lib.genAttrs sokolModules (moduleName:
    final.callPackage (mkSokolLib {
      inherit lib;
      lname = moduleName;
    }) {inherit sokol-odin-src;})

[
  (final: prev: {
    odinLibs = prev.lib.packagesFromDirectoryRecursive {
      inherit (prev) callPackage;
      directory = ../packages/odinLibs;
    };
  })
  (final: prev: {
    # TODO: Wait for https://github.com/odin-lang/Odin/pull/4619 to be merged
    odin = prev.odin.overrideAttrs {
      patches = [
        ./odin.patch
      ];
    };

    # TODO: Wait for https://github.com/NixOS/nixpkgs/pull/357729 to be merged
    raylib = prev.callPackage ../packages/raylib {};

    sokol-shdc = prev.callPackage ../packages/sokol-shdc {};
  })
]

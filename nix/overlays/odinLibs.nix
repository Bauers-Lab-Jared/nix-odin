final: prev: {
  odinLibs = prev.lib.packagesFromDirectoryRecursive {
    inherit (prev) callPackage;
    directory = ../odinLibs;
  };
}

{lib, pkgs, ...}: {
  export = {
    lib = { 
      buildOdin = import ./buildOdin.nix {inherit lib pkgs;};
     };
      odin-libs = lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ./odin-libs;
      };
  };
}

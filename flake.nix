{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: let
    out = system: let
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      package = lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ./libs;
      };
    };
  in
    flake-utils.lib.eachDefaultSystem out;
}

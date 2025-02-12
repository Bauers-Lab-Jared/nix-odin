{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:bauers-lab-jared/nixvim";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    inherit (nixpkgs) lib;
    out = system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [(import ./nix/overlays {inherit lib;})];
      };
    in {
      packages = {
        inherit (pkgs) odinLibs;
      };
      devShells.default = pkgs.mkShell {
        packages = [
          (self.inputs.nixvim.lib.mkNixvim {
            pkgs = self.inputs.nixvim.inputs.nixpkgs.legacyPackages.${system};
            addons = [
              "proj-odin"
              "proj-nix"
            ];
          })
        ];
      };
    };
  in
    flake-utils.lib.eachDefaultSystem out
    // {
      overlays.default = final: prev: {
        buildOdin = import ./buildOdin.nix {pkgs = prev;};
      };
    };
}

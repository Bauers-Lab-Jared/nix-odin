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
    out = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      appliedOverlay = import nixpkgs {
        inherit system;
        overlays = self.overlays.list;
      };
    in {
      packages = {
        inherit (appliedOverlay) odinLibs buildOdin odinConfig;
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
      overlays.list = import ./nix/overlays;
      buildOdin = import ./nix/buildOdin.nix;
    };
}

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
      pkgs = nixpkgs.legacyPackages.${system};
      appliedOverlay = self.overlays.default pkgs pkgs;
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
      overlays.default = import ./nix/overlays {inherit lib;};
    };
}

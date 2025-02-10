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
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in (import ./nix {inherit lib pkgs;}).export // {
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
    flake-utils.lib.eachDefaultSystem out;
}

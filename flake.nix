{
  description = "Reusable package fixes for Nixpkgs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = lib.genAttrs systems;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
    in
    {
      overlays.default = import ./overlay.nix;
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        lib.filterAttrs (
          name: package:
          lib.meta.availableOn pkgs.stdenv.hostPlatform package
          # The locked btrbk recipe permits Unix but needs Linux-only btrfs-progs.
          && (name != "btrbk" || pkgs.stdenv.hostPlatform.isLinux)
        ) (self.overlays.default pkgs pkgs)
      );
      checks = forAllSystems (
        system:
        self.packages.${system}
        // {
          overlay-contract = import ./tests/overlay-contract.nix {
            inherit lib;
            pkgs = pkgsFor system;
            upstream = import nixpkgs { inherit system; };
          };
        }
      );
      formatter = forAllSystems (system: (pkgsFor system).nixfmt);
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt
              pkgs.quilt
            ];
          };
        }
      );
    };
}

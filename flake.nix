{
  description =
    "Collection of nix-compatible color schemes, and a home-manager module to make theming easier.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    # Upstream source of .yaml schemes
    schemes.url = "github:tinted-theming/schemes";
    schemes.flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs-lib, schemes }: rec {
    instantiate = { system }: (import ./. {
      pkgs = import nixpkgs { inherit system; };
      nixpkgs-lib = nixpkgs-lib.lib;
      schemes = schemes.outPath;
    });
    "x86_64-linux" = instantiate { system = "x86_64-linux"; };
  };
}

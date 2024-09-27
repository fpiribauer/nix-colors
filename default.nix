let
  inherit (builtins.fromJSON (builtins.readFile ./flake.lock)) nodes;
  # Fetch using flake lock, for legacy compat
  fromFlake = name:
    let inherit (nodes.${name}) locked;
    in fetchTarball {
      url =
        "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
      sha256 = locked.narHash;
    };

in
{ system ? builtins.currentSystem
, nixpkgs ? import (fromFlake "nixpkgs")
, nixpkgs-lib ? import ((fromFlake "nixpkgs-lib") + "/lib")
, schemes ? fromFlake "schemes"
, ...
}: rec {
  pkgs = import nixpkgs { inherit system; allowUnfree = false; };
  lib-contrib = import ./lib/contrib { inherit nixpkgs-lib; };
  lib-core = import ./lib/core { inherit pkgs nixpkgs-lib; };
  lib = lib-core // { contrib = lib-contrib; };

  tests = import ./lib/core/tests { inherit pkgs nixpkgs-lib; };

  colorSchemes = import ./schemes.nix { inherit lib schemes nixpkgs-lib; };
  # Alias
  colorschemes = colorSchemes;

  homeManagerModules = rec {
    colorScheme = import ./module;
    # Alias
    colorscheme = colorScheme;
    default = colorScheme;
  };
  homeManagerModule = homeManagerModules.colorScheme;
}

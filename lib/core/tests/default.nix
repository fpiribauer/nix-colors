{ pkgs, nixpkgs-lib }: {
  math = import ./math.nix { inherit nixpkgs-lib; };
  conversions = import ./conversions.nix { inherit nixpkgs-lib; };
  schemeFromYAML = import ./schemeFromYAML.nix { inherit pkgs nixpkgs-lib; };
}

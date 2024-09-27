{ pkgs, nixpkgs-lib }:
let
  fromYAML = yaml:
    let
      file = pkgs.writeText "from-yaml" yaml;
      json = pkgs.runCommand "to-json" {} ''${pkgs.yq-go}/bin/yq -p yaml -o json ${file} > $out'';
    in
    (builtins.fromJSON (builtins.readFile json));

  convertScheme = slug: set: rec {
    name = set.scheme or set.name;
    inherit (set) author;
    inherit slug;
    palette = set.palette or (
      nixpkgs-lib.attrsets.filterAttrs (k: v: !(builtins.elem k ["author" "scheme" "name" "slug" "system" "variant"])) set
    );
    system = set.system or (
      if builtins.hasAttr "base10" palette then "base24" else "base16"
    );
  } // (nixpkgs-lib.attrsets.optionalAttrs (builtins.hasAttr "variant" set) { variant = set.variant; });


  schemeFromYAML = slug: content: convertScheme slug (fromYAML content);
in
schemeFromYAML

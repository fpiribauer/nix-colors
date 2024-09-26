{ pkgs, nixpkgs-lib }:
let
  inherit (builtins)
    elemAt filter listToAttrs substring replaceStrings stringLength genList;

  # All of these are borrowed from nixpkgs
  mapListToAttrs = f: l: listToAttrs (map f l);
  escapeRegex = escape (stringToCharacters "\\[{()^$?*+|.");
  addContextFrom = a: b: substring 0 0 a + b;
  escape = list: replaceStrings list (map (c: "\\${c}") list);
  range = first: last:
    if first > last then [ ] else genList (n: first + n) (last - first + 1);
  stringToCharacters = s:
    map (p: substring p 1 s) (range 0 (stringLength s - 1));
  splitString = _sep: _s:
    let
      sep = builtins.unsafeDiscardStringContext _sep;
      s = builtins.unsafeDiscardStringContext _s;
      splits = filter builtins.isString (builtins.split (escapeRegex sep) s);
    in
    map (v: addContextFrom _sep (addContextFrom _s v)) splits;
  nameValuePair = name: value: { inherit name value; };

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

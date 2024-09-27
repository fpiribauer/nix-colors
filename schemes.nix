{ lib, nixpkgs-lib, schemes, ... }:
let
  inherit (builtins)
    readFile readDir attrNames listToAttrs stringLength substring baseNameOf
    filter;
  foldlAttrs = nixpkgs-lib.attrsets.foldlAttrs;
  inherit (lib) schemeFromYAML;

  # Borrowed from nixpkgs
  removeSuffix = suffix: str:
    let
      sufLen = stringLength suffix;
      sLen = stringLength str;
    in
    if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str then
      substring 0 (sLen - sufLen) str
    else
      str;
  hasSuffix = suffix: content:
    let
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix
    && substring (lenContent - lenSuffix) lenContent content == suffix;

  stripYamlExtension = filename:
    removeSuffix ".yml" (removeSuffix ".yaml" filename);
  isYamlFile = filename:
    (hasSuffix ".yml" filename) || (hasSuffix ".yaml" filename);

  getColorSchemeFiles = source: system:
    filter isYamlFile (attrNames (readDir "${source}/${system}"));

  getColorSchemes = schemes:
  let
    dir = (builtins.readDir schemes);
  in
  foldlAttrs (a: n: v:
    # Ignore files starting with dot (hidden)
    if (builtins.substring 0 1 n) == "." then
      a
    else if v == "regular" && isYamlFile n then
      let
        stripped = stripYamlExtension n;
      in
      a // { ${stripped} = schemeFromYAML stripped (builtins.readFile "${schemes}/${n}"); }
    else if v == "directory" then
      let
        subresult =  getColorSchemes "${schemes}/${n}";
      in
      if subresult == {}  then a else a // { ${n} = subresult; }
    else # Do not follow symlinks or unknown files
      a
    ) {} dir;

  colorSchemes = getColorSchemes (schemes);
in
colorSchemes

# to run these tests:
# nix eval .#tests.schemeFromYAML
# if the resulting list is empty, all tests passed
{ pkgs, nixpkgs-lib }:
let
  schemeFromYAML = import ../schemeFromYAML.nix { inherit pkgs nixpkgs-lib; };
  runTests = pkgs.lib.debug.runTests;
in
(runTests {
  test_base16_old = {
    expr = (schemeFromYAML
      "atelier-dune-light"
      ''
      scheme: "Atelier Dune Light"
      author: "Bram de Haan (http://atelierbramdehaan.nl)"
      base00: "fefbec"
      base01: "e8e4cf"
      base02: "a6a28c"
      base03: "999580"
      base04: "7d7a68"
      base05: "6e6b5e"
      base06: "292824"
      base07: "20201d"
      base08: "d73737"
      base09: "b65611"
      base0A: "ae9513"
      base0B: "60ac39"
      base0C: "1fad83"
      base0D: "6684e1"
      base0E: "b854d4"
      base0F: "d43552"
      ''
      );
    expected = {
      system = "base16";
      slug = "atelier-dune-light";
      name = "Atelier Dune Light";
      author = "Bram de Haan (http://atelierbramdehaan.nl)";
      palette = {
        base00 = "fefbec";
        base01 = "e8e4cf";
        base02 = "a6a28c";
        base03 = "999580";
        base04 = "7d7a68";
        base05 = "6e6b5e";
        base06 = "292824";
        base07 = "20201d";
        base08 = "d73737";
        base09 = "b65611";
        base0A = "ae9513";
        base0B = "60ac39";
        base0C = "1fad83";
        base0D = "6684e1";
        base0E = "b854d4";
        base0F = "d43552";
      };
    };
  };
  test_base16_new = {
    expr = (schemeFromYAML
      "apprentice"
      ''
      system: "base16"
      name: "Apprentice"
      author: "romainl"
      variant: "dark"
      palette:
        base00: "262626"
        base01: "AF5F5F"
        base02: "5F875F"
        base03: "87875F"
        base04: "5F87AF"
        base05: "5F5F87"
        base06: "5F8787"
        base07: "6C6C6C"
        base08: "444444"
        base09: "FF8700"
        base0A: "87AF87"
        base0B: "FFFFAF"
        base0C: "87AFD7"
        base0D: "8787AF"
        base0E: "5FAFAF"
        base0F: "BCBCBC"
      ''
      );
    expected = {
      system = "base16";
      slug = "apprentice";
      name = "Apprentice";
      author = "romainl";
      variant =  "dark";
      palette = {
        base00 = "262626";
        base01 = "AF5F5F";
        base02 = "5F875F";
        base03 = "87875F";
        base04 = "5F87AF";
        base05 = "5F5F87";
        base06 = "5F8787";
        base07 = "6C6C6C";
        base08 = "444444";
        base09 = "FF8700";
        base0A = "87AF87";
        base0B = "FFFFAF";
        base0C = "87AFD7";
        base0D = "8787AF";
        base0E = "5FAFAF";
        base0F = "BCBCBC";
      };
    };
  };

  test_base24_github = {
    expr = ( schemeFromYAML
    "github"
    ''
    system: "base24"
    name: "Github"
    author: "FredHappyface (https://github.com/fredHappyface)"
    variant: "light"
    palette:
      base00: "f4f4f4"
      base01: "3e3e3e"
      base02: "666666"
      base03: "8c8c8c"
      base04: "b2b2b2"
      base05: "d8d8d8"
      base06: "ffffff"
      base07: "ffffff"
      base08: "970b16"
      base09: "f8eec7"
      base0A: "2e6cba"
      base0B: "07962a"
      base0C: "89d1ec"
      base0D: "003e8a"
      base0E: "e94691"
      base0F: "4b050b"
      base10: "444444"
      base11: "222222"
      base12: "de0000"
      base13: "f1d007"
      base14: "87d5a2"
      base15: "1cfafe"
      base16: "2e6cba"
      base17: "ffa29f"
    ''
    );
    expected = {
      system = "base24";
      slug = "github";
      name = "Github";
      author = "FredHappyface (https://github.com/fredHappyface)";
      variant = "light";
      palette = {
        base00 = "f4f4f4";
        base01 = "3e3e3e";
        base02 = "666666";
        base03 = "8c8c8c";
        base04 = "b2b2b2";
        base05 = "d8d8d8";
        base06 = "ffffff";
        base07 = "ffffff";
        base08 = "970b16";
        base09 = "f8eec7";
        base0A = "2e6cba";
        base0B = "07962a";
        base0C = "89d1ec";
        base0D = "003e8a";
        base0E = "e94691";
        base0F = "4b050b";
        base10 = "444444";
        base11 = "222222";
        base12 = "de0000";
        base13 = "f1d007";
        base14 = "87d5a2";
        base15 = "1cfafe";
        base16 = "2e6cba";
        base17 = "ffa29f";
      };
    };
  };


})

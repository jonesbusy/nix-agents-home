{ opencode }:
{ pkgs, ... }:
let
  opencodePackage = opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
  # shortcut: v2.3.0's upstream x86_64-linux node_modules hash is stale; remove when upstream updates it.
  package =
    if
      opencodePackage.version == "2.3.0+a6b15d3" && pkgs.stdenv.hostPlatform.system == "x86_64-linux"
    then
      opencodePackage.overrideAttrs (old: {
        node_modules = old.node_modules.overrideAttrs (_: {
          outputHash = "sha256-PYcpyYP/i0e6ZIt27u1tFYbjU4Cl848w77dU1NiIEls=";
        });
      })
    else
      opencodePackage;
in
{
  programs.opencode = {
    enable = true;
    inherit package;
  };
}

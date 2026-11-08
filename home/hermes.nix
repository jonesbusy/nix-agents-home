{ hermes-agent }:
{ lib, pkgs, ... }:
let
  hermesPackages = hermes-agent.packages.${pkgs.stdenv.hostPlatform.system};
  pmNames = builtins.filter (name: lib.hasPrefix "pm-" name) (builtins.attrNames hermesPackages);
  pmPackages = lib.listToAttrs (
    map (name: lib.nameValuePair (lib.removePrefix "pm-" name) hermesPackages.${name}) pmNames
  );
  hermesPackage = hermesPackages.default.override {
    pmPackages = pmPackages // {
      node = pkgs.nodejs_26;
    };
  };
in
{
  imports = [ hermes-agent.homeManagerModules.default ];

  programs.hermes-agent = {
    enable = true;
    package = hermesPackage;
  };

  home.activation.secureHermesHomeDirectory = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    builtins.readFile ./hermes-state.sh
  );
}

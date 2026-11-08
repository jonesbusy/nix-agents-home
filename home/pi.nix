{ pi }:
{ pkgs, ... }:
{
  home.packages = [ pi.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}

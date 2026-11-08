let
  flake = builtins.getFlake (toString ../.);
  moduleNames = [
    "pi"
    "hermes"
    "opencode"
    "default"
  ];
  check = flake.checks.x86_64-linux.home-manager-modules;
in
assert builtins.all (name: builtins.hasAttr name flake.homeManagerModules) moduleNames;
assert check.drvPath != "";
true

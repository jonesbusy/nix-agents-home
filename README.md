# Nix Agents Home

Reusable Home Manager modules for installing agent applications. This flake provides modules for Pi, Hermes Agent, and OpenCode. It installs and wires up the applications; it does not define personal models, providers, MCP servers, extensions, plugins, or account-specific paths.

## Use in a Home Manager flake

Add the flake input:

```nix
nix-agents-home = {
  url = "github:jonesbusy/nix-agents-home";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
};
```

Import all three modules:

```nix
modules = [
  inputs.nix-agents-home.homeManagerModules.default
  # Your personal settings and configuration files
];
```

Or import only the applications you use:

```nix
modules = [
  inputs.nix-agents-home.homeManagerModules.pi
  inputs.nix-agents-home.homeManagerModules.hermes
  inputs.nix-agents-home.homeManagerModules.opencode
];
```

Keep application configuration in your own Home Manager modules. Agent skills are managed separately by [nix-agents-skills](https://github.com/jonesbusy/nix-agents-skills).

## Validate

With Nix flakes and `prek` installed, run:

```sh
bash tests/hermes-state.sh
nix eval --impure --file tests/modules.nix
nix flake check --no-build
prek run --all-files
```

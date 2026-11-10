{
  description = "Reusable Home Manager modules for agent applications";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pi.url = "github:earendil-works/pi/v1.5.2";

    opencode.url = "github:anomalyco/opencode/v2.2.6";

    hermes-agent = {
      url = "github:NousResearch/hermes-agent/v0.23.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      pi,
      opencode,
      hermes-agent,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      piModule = import ./home/pi.nix { inherit pi; };
      hermesModule = import ./home/hermes.nix { inherit hermes-agent; };
      opencodeModule = import ./home/opencode.nix { inherit opencode; };
      modules = {
        pi = piModule;
        hermes = hermesModule;
        opencode = opencodeModule;
        default = { ... }: {
          imports = [
            piModule
            hermesModule
            opencodeModule
          ];
        };
      };
      testConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          modules.default
          {
            home.username = "test";
            home.homeDirectory = "/tmp/nix-agents-home-test";
            home.stateVersion = "25.05";
          }
        ];
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      homeManagerModules = modules;

      checks.${system}.home-manager-modules =
        assert testConfig.config.programs.hermes-agent.enable;
        assert testConfig.config.programs.hermes-agent.package != null;
        assert testConfig.config.programs.opencode.enable;
        assert testConfig.config.programs.opencode.package != null;
        assert builtins.elem pi.packages.${system}.default testConfig.config.home.packages;
        assert !(builtins.hasAttr ".pi/agent/settings.json" testConfig.config.home.file);
        assert !(builtins.hasAttr ".hermes/config.yaml" testConfig.config.home.file);
        assert !(builtins.hasAttr ".config/opencode/opencode.json" testConfig.config.home.file);
        pkgs.runCommand "nix-agents-home-manager-modules" { } "touch $out";
    };
}

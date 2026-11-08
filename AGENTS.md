# Repository guidance

This flake exports reusable Home Manager modules for agent applications. Keep application package wiring in `home/` and keep user-specific settings, agent configuration files, skill sources, and host configuration out of this repository.

## Validate

Stage new and modified files before evaluating the flake so Nix includes them. Run:

```sh
bash tests/hermes-state.sh
nix eval --impure --file tests/modules.nix
nix flake check --no-build
prek run --all-files
```

Do not activate Home Manager or change installed tools from this repository unless explicitly requested. Do not push without explicit user approval. Never add credentials or private agent state.

Keep GitHub Actions permissions read-only unless a workflow feature requires more, avoid privileged pull-request triggers, and pin actions to full commit SHAs.

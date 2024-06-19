# nixos-tests

## Installation

To use these options, add to your flake inputs:

```nix
nixos-tests.url = "github:esselius/nixos-tests";
```

and inside the `mkFlake`:

```nix
imports = [
  inputs.nixos-tests.flakeModule
];
```
# nixos-tests


[nixos-tests](https://github.com/esselius/nixos-tests) lets you put nixos tests in a folder and run them with `nix run .#nixosTest.my-test`.

Example usage when combined with [ez-configs](https://flake.parts/options/ez-configs): https://github.com/esselius/nixos-tests-flake-parts


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

Run `nix flake lock` and you're set.

## Options


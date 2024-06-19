{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-tests.url = "github:esselius/nixos-tests";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }: {
      imports = [ inputs.nixos-tests.flakeModule ];

      systems = [ "aarch64-linux" "aarch64-darwin" "x86_64-linux" "x86_64-darwin"  ];

      perSystem = { pkgs, ... }: {
        nixosTests = {
          path = ./tests;
          args = {
            inherit inputs;
          };
        };
      };
    });
}

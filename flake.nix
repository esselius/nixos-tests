{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    {
      systems = [ "aarch64-linux" "aarch64-darwin" "x86_64-linux" "x86_64-darwin"  ];

      flake = {
        flakeModule = import ./flake-module.nix;
        templates.default = {
          path = ./template;
          description = "Basic nixos tests flake";
        };
      };
    };
}

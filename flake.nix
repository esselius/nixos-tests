{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    {
      flake.flakeModule = import ./flake-module.nix;
    };
}

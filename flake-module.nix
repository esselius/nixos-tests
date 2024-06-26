{ lib, flake-parts-lib, ... }:
let
  inherit (lib) concatMapAttrs mkOption types;
  inherit (builtins) readDir;
  inherit (lib.strings) removeSuffix;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({ config, pkgs, ... }:
      let
        testDriver = path: (pkgs.testers.runNixOSTest (interimModule path)).driver;
        interimModule = m: { imports = [m]; _module = { inherit (config.nixosTests) args; }; };
        nixosTests = dir: a: _: { ${removeSuffix ".nix" a} = testDriver (dir + ("/" + a)); };
        mkLegacyPackages = dir: concatMapAttrs (nixosTests dir) (readDir dir);
      in
      {
        options.nixosTests = {
          path = mkOption {
            type = types.pathInStore;
            description = "Path to NixOS tests folder";
          };
          args = mkOption {
            default = {};
            type = types.attrsOf types.anything;
            description = "Args to pass to each test";
          };
        };
        config.legacyPackages.nixosTests = mkLegacyPackages config.nixosTests.path;
      });
  };
}

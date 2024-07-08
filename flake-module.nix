{ lib, flake-parts-lib, pkgs, ... }:
let
  inherit (lib) concatMapAttrs mkOption types mapAttrsToList concatMap flatten;
  inherit (builtins) readDir;
  inherit (lib.strings) removeSuffix;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({ config, pkgs, ... }:
      let
        testDriver = path: (pkgs.testers.runNixOSTest (interimModule path)).driver;
        wrapper = path: pkgs.runCommand "nixos-test-driver" { nativeBuildInputs = [ pkgs.makeWrapper ]; buildInputs = [ (testDriver path) ]; } ''
          mkdir -p $out/bin
          ln -s ${testDriver path}/bin/nixos-test-driver $out/bin/nixos-test-driver
          wrapProgram $out/bin/nixos-test-driver \
            ${lib.escapeShellArgs (lib.flatten (lib.concatMap (arg: ["--set" arg]) (lib.mapAttrsToList (k: v: [k v]) config.nixosTests.env)))}
        '';
        interimModule = m: { imports = [ m ]; _module = { inherit (config.nixosTests) args; }; };
        nixosTests = dir: a: _: { ${removeSuffix ".nix" a} = wrapper (dir + ("/" + a)); };
        mkLegacyPackages = dir: concatMapAttrs (nixosTests dir) (readDir dir);
      in
      {
        options.nixosTests = {
          path = mkOption {
            type = types.pathInStore;
            description = "Path to NixOS tests folder";
          };
          args = mkOption {
            default = { };
            type = types.attrsOf types.anything;
            description = "Args to pass to each test";
          };
          env = mkOption {
            default = { };
            type = types.attrsOf types.anything;
            description = "Environment variables to set during test";
          };
        };
        config.legacyPackages.nixosTests = mkLegacyPackages config.nixosTests.path;
      });
  };
}

{
  config,
  pkgs,
  lib,
  unstablePkgs,
  ...
}: self: super: {
  beetsPackages =
    super.beetsPackages
    // {
      beets-unstable = super.beetsPackages.beets-unstable.override {
        src = pkgs.fetchFromGitHub {
          owner = "bcotton";
          repo = "beets";
          rev = "f4502f0e73df3ba357ee3d820a47c4711062414a";
          hash = "sha256-Ud2cZ9LKbs9KKgXac0rmWkxexPVg2Gf2OqVgh7GllB8=";
        };
        extraPatches = [
          # Bash completion fix for Nix
          # ./patches/bash-completion-always-print.patch
        ];
        pluginOverrides = {
          lap = {
            enable = true;
            propagatedBuildInputs = [(pkgs.python3.pkgs.callPackage ../pkgs/lap {})];
          };
          beets_id3extract = {
            enable = true;
            propagatedBuildInputs = [(pkgs.python3.pkgs.callPackage ../pkgs/beets_id3extract {})];
          };
        };
        pluginOverrides = {
          _typing = {
            enable = true;
            builtin = true;
            testPaths = [];
          };
        };
        extraNativeBuildInputs = with pkgs.python3Packages; [
          requests-mock
        ];
      };
    };
}

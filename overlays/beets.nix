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
          rev = "4a2647590375e684aa21fbf0732df0ebd5ba0671";
          hash = "sha256-g9r+pehlSoN0oz7e+bc9WbYrH9+GVwwqgZ/Iu89lSx8=";
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

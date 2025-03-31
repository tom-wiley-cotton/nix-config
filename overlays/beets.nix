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
          rev = "aa265b4fc8716666aef82f035787ecc22a4e0403";
          hash = "sha256-eUtAtYxkhEViifyKZT4t0T16hp8zatdvcKPsMSDCqaA=";
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

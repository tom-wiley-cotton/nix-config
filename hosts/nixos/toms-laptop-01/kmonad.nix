{
  pkgs,
  unstablePkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in {
  environment.systemPackages = with pkgs; [
    kmonad
  ];

  services.kmonad = {
    enable = true;
    keyboards = {
      toms-laptop-01 = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = builtins.readFile ./toms-laptop-01.kbd;
      };
    };
  };
}

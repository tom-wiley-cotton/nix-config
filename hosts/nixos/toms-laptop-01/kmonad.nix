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
    configfiles = [ ./toms-laptop-01.kbd ];
  };
}

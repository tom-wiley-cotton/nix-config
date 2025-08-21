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
    kitty
  ];

  programs.hyprland.enable = true;
  programs.waybar.enable = true;
}

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

  home.file.".config/hypr" = {
    enable = true;
    source = "../../home/tomcotton.config/hypr";
    target = ".config/hypr";
  };
  
  home.file.".config/waybar" = {
    enable = true;
    source = "../../home/tomcotton.config/waybar";
    target = ".config/waybar";
  };
}

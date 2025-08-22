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
    dunst
    hyprpaper
    hypridle
    hyprlock
    hyprsunset
    wofi
    grim
    slurp
    swappy
  ];

  # services.dunst.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.waybar.enable = true;

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
}

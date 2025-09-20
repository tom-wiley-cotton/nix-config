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
    gnomeExtensions.tiling-shell
    dconf2nix # used to make a nix expression from the dconf bin
  ];
  fonts.packages = with pkgs; [
    font-awesome
    font-awesome_5
    nerd-fonts.fira-code           # Popular monospace font with good symbol support
    nerd-fonts.jetbrains-mono     # Clear monospace font with excellent readability
    nerd-fonts.noto               # Clean sans-serif font with extensive unicode support
    nerd-fonts.roboto-mono        # Google's monospace font with added symbols
    nerd-fonts.ubuntu-mono        # Ubuntu's monospace font with added symbols
    papirus-icon-theme
  ];

# Pre 25.11
services.xserver.enable = true;
services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.gnome.enable = true;

# services.xserver = {
#     enable = true;
#     desktopManager = {
#       xterm.enable = false;
#     };
#     windowManager.i3 = {
#       enable = true;
#       extraPackages = with pkgs; [
#         dmenu #application launcher most people use
#         i3status # gives you the default i3 status bar
#         i3blocks #if you are planning on using i3blocks over i3status
#       ];
#     };
#   };

    # services.displayManager.sddm.enable = true;
    # services.desktopManager.plasma6.enable = true;

    # systemd.services.myCustomService = {
    #     description = "Launch Plasma with i3";
    #     before = [ "plasma-workspace.target" ];
    #     wantedBy = [ "plasma-workspace.target" ]; # Or other targets like "graphical.target"
    #     serviceConfig = {
    #         Type = "simple"; # Or "forking", "oneshot", etc.
    #         ExecStart = "/usr/bin/i3";
    #         Restart = "on-failure";
    #     };
        # Optional: Define dependencies or other unit options
        # after = [ "network.target" ];
    # };
}

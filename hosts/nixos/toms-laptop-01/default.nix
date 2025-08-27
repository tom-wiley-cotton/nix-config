# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  pkgs,
  lib,
  unstablePkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../../modules/node-exporter
    ../../../modules/nfs
    ../../../home/toms-hyprland.nix
    ../../../home/toms-guipkgs.nix
    ../../../home/toms-proaudio.nix
    ./kmonad.nix # enables kmonad and points to .kbd
  ];

  services.clubcotton = {
    tailscale.enable = true;
  };

  # === Audio Friendly Kernel Mods ===
  musnix.enable = true; # Makes lots of system and kernel modifications for audio friendlyness
  musnix.kernel.realtime = true; # Switches the kernel to a realtime kernel

  services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.libvirtd.enable = true;

  clubcotton.zfs_single_root = {
    enable = true;
    poolname = "rpool";
    swapSize = "4G";
    disk = "/dev/disk/by-id/ata-WDC_WD10SPZX-60Z10T0_WD-WXS1A9855YLP";
    useStandardRootFilesystems = true;
    reservedSize = "20GiB";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

	nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.12.40"
    "broadcom-sta-6.30.223.271-57-6.6.30-rt30"
  ];


  networking = {
    hostName = "toms-laptop-01";
    hostId = "a8c01005";

    networkmanager.enable = true;

    # useDHCP = false;
    # defaultGateway = "192.168.5.1";
    # nameservers = ["192.168.5.220"];
    # interfaces.wlp0s20f0u1.ipv4.addresses = [
    #   {
    #     address = "192.168.5.16";
    #     prefixLength = 24;
    #   }
    # ];
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  programs.zsh.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKW08oClThlF1YJ+ey3y8XKm9yX/45EtaM/W7hx5Yvzb tomcotton@Toms-MacBook-Pro.local"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    firefox
    vscode
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}

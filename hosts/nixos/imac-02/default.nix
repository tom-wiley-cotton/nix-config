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
  ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.sane.enable = true;

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };

  clubcotton.zfs_single_root = {
    enable = true;
    poolname = "rpool";
    swapSize = "4G";
    disk = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S59CNM0R836896T";
    useStandardRootFilesystems = true;
    reservedSize = "20GiB";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    useDHCP = true;
    hostName = "imac-02";
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "95c41ddc";
    defaultGateway = "192.168.5.1";
    nameservers = ["192.168.5.220"];
    wireless.enable = true;
    wireless.userControlled.enable = true;
    wireless.secretsFile = config.age.secrets.wireless-config.path;
    wireless.networks = {
      "clubcotton2" = {
        pskRaw = "ext:PSK";
      };
    };
  };

  services.tailscale.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  programs.zsh.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA51nSUvq7WevwvTYzD1S2xSr9QU7DVuYu3k/BGZ7vJ0 bob.cotton@gmail.com"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.enable = false;

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    code-cursor
    scanbd
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}

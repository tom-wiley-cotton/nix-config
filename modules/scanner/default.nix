{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  service = "scanner";
  cfg = config.services.clubcotton.${service};
  clubcotton = config.clubcotton;

  scanScript =
    pkgs.writeScript "scanbd_scan.script"
    ''
      #! ${pkgs.bash}/bin/bash
      export PATH=${lib.makeBinPath [pkgs.coreutils pkgs.sane-frontends pkgs.sane-backends pkgs.ghostscript pkgs.imagemagick]}
      user=$(1:-bcotton)

      set -x
      date="$(date --iso-8601=seconds)"
      filename="Scan_$date.pdf"
      tmpdir="$(mktemp -d)"
      pushd "$tmpdir"
      scanimage -b --format png -d 'fujitsu:ScanSnap iX500:355763' --source 'ADF Duplex' --resolution 300 --mode Color

      # Convert any PNM images produced by the scan into a PDF with the date as a name
      magick out* -density 300 "$filename"
      chmod 0666 "$filename"

      # Remove temporary PNM images
      rm --verbose out*

      scp -o 'StrictHostKeyChecking=no' -i ${config.age.secrets.scanner-user-private-ssh-key.path} $filename scanner@nas-01:/var/lib/paperless/consume/$user

      rm -r "$tmpdir"
    '';
in {
  options.services.clubcotton.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.sane.enable = true;
    environment.systemPackages = [pkgs.imagemagick];
    environment.etc."scan-script".source = scanScript;

    # This is the IDs of the ScanSnap scanner
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="04c5", ATTRS{idProduct}=="132b", GROUP="scanner"
    '';

    users.users.scanner = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = ["share" "scanner" "paperless"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA51nSUvq7WevwvTYzD1S2xSr9QU7DVuYu3k/BGZ7vJ0 bob.cotton@gmail.com"
        # the home assistant ssh key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfaVRy27kV2P99ymnqz8A1RbJ2qpR/eiHqAYWxb2vdy root@core-ssh"
        # The coorsponding private key is in agenix
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZqnyZ2g0YVCM5KNyVwnIiOcQMC2Uc5bBzrWevyDnwt scanner@imac-02"
      ];
    };
  };
}

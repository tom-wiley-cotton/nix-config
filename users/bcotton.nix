{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  users.users.bcotton = {
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "incus-admin" "podman" "share" "scanner"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$G9latKdzvUGuwcba$/8qQObrrQdMYIpQMXV4.04Zn1zhvZmtATFM5iSrmWgL9jybIkh7B1sHMhr2l/6jDhXz80OjAWQuFFsdQUTQyp.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA51nSUvq7WevwvTYzD1S2xSr9QU7DVuYu3k/BGZ7vJ0 bob.cotton@gmail.com"
    ];
    packages = with pkgs; [
      tree
      tmux
      git
    ];
  };
}

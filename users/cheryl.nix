{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  users.users.cheryl = {
    shell = pkgs.zsh;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSbpQ7NNYBQnmw4rOIhqjaLFWPVJANdoaNxMM73cSmE cheryl@nas-01"
    ];
  };
}

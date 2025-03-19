{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  service = "nut-client";
  cfg = config.services.clubcotton.${service};
in {
  options.services.clubcotton.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
  };
  config = lib.mkIf cfg.enable {
    power.ups = {
      enable = true;
      mode = "netclient"; # This will be overridden by mkForce "netserver" on the actual server

      upsmon.settings = {
        POWERDOWNFLAG = "/var/state/ups/killpower";
        NOTIFYFLAG = [
          [
            "ONLINE"
            "SYSLOG+WALL"
          ]
          [
            "ONBATT"
            "SYSLOG+WALL"
          ]
          [
            "LOWBATT"
            "SYSLOG+WALL"
          ]
          [
            "FSD"
            "SYSLOG+WALL"
          ]
          [
            "COMMOK"
            "EXEC"
          ]
          [
            "COMMBAD"
            "EXEC"
          ]
          [
            "SHUTDOWN"
            "SYSLOG+WALL"
          ]
          [
            "REPLBATT"
            "SYSLOG+WALL"
          ]
          [
            "NOCOMM"
            "SYSLOG+WALL+EXEC"
          ]
          [
            "NOPARENT"
            "SYSLOG+WALL"
          ]
        ];
      };
      upsmon.monitor.server-rack-ups = {
        user =
          if config.power.ups.mode == "netserver"
          then "primary-client"
          else "secondary-client";
        system = "server-rack-ups@admin.lan:3493";
        passwordFile = config.age.secrets.nut-client-password.path;
        type = let
          match = {
            netserver = "primary";
            netclient = "secondary";
          };
        in
          match.${config.power.ups.mode};
      };
    };
    # imports = [./upssched.nix];
  };
}

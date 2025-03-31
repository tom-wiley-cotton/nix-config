{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.clubcotton.tailscale;
in {
  options.services.clubcotton.tailscale = {
    enable = mkEnableOption "tailscale service";

    useRoutingFeatures = mkOption {
      type = types.enum ["none" "client" "server" "both"];
      default = "none";
      example = "server";
      description = ''
        Enables settings required for Tailscale's routing features like subnet routers and exit nodes.

        To use these these features, you will still need to call `sudo tailscale up` with the relevant flags like `--advertise-exit-node` and `--exit-node`.

        When set to `client` or `both`, reverse path filtering will be set to loose instead of strict.
        When set to `server` or `both`, IP forwarding will be enabled.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
    networking.firewall.trustedInterfaces = ["tailscale0"];

    services.tailscale = {
      enable = true;
      package = pkgs.tailscale;
      authKeyFile = config.age.secrets.tailscale-keys.path;
      useRoutingFeatures = cfg.useRoutingFeatures;
    };

    # Add oneshot service to enable webclient
    systemd.services.tailscale-webclient = {
      description = "Enable Tailscale webclient";
      after = ["tailscale.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.tailscale}/bin/tailscale set --webclient";
        RemainAfterExit = true;
      };
    };
  };
}

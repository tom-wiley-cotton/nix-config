{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.clubcotton.postgresql;
in {
  options.services.clubcotton.postgresql = {
    tfstate = {
      enable = mkEnableOption "TF State store";

      database = mkOption {
        type = types.str;
        default = "tfstate";
        description = "Name of the TF state database.";
      };

      user = mkOption {
        type = types.str;
        default = "tfstate";
        description = "Name of the TF state database user.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to the user's password file.";
      };
    };
  };

  config = mkIf (cfg.enable && cfg.tfstate.enable) {
    services.postgresql = {
      ensureDatabases = [cfg.tfstate.database];
      ensureUsers = [
        {
          name = cfg.tfstate.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };

    # Set password from file if passwordFile is provided
    systemd.services.postgresql.postStart = mkIf (cfg.tfstate.passwordFile != null) (let
      password_file_path = cfg.tfstate.passwordFile;
    in ''
      $PSQL -tA <<'EOF'
        DO $$
        DECLARE password TEXT;
        BEGIN
          password := trim(both from replace(pg_read_file('${password_file_path}'), E'\n', '''));
          EXECUTE format('ALTER ROLE "${cfg.tfstate.database}" WITH PASSWORD '''%s''';', password);
        END $$;
      EOF
    '');

    services.clubcotton.postgresql.postStartCommands = let
      sqlFile = pkgs.writeText "tfstate-setup.sql" ''
        ALTER SCHEMA public OWNER TO "${cfg.tfstate.user}";
      '';
    in [
      ''
        ${lib.getExe' config.services.postgresql.package "psql"} -p ${toString cfg.port} -d "${cfg.tfstate.database}" -f "${sqlFile}"
      ''
    ];
  };
}

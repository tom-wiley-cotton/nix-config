{
  config,
  pkgs,
  ...
}: let
in {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "CLUBCOTTON";
        "server string" = "nas-01";
        "netbios name" = "nas-01";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.5. 127.0.0.1 localhost 100.";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "backups-bcotton" = {
        "path" = "/backups/bcotton";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "bcotton";
        "force group" = "users";
      };
      "backups-tomcotton" = {
        "path" = "/backups/tomcotton";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "tomcotton";
        "force group" = "users";
      };
      "media-tomcotton" = {
        "path" = "/media/tomcotton";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "tomcotton";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}

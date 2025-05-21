{
  lib,
  unstablePkgs,
  ...
}: {
  imports = [
    ./jellyseerr
    ./lidarr
    ./prowlarr
    ./radarr
    ./readarr-multi
    ./readarr
    ./sonarr
  ];
}

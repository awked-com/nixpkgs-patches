final: prev:
let
  inherit (final) lib;
in
# Import upstream wrappers directly so they retain upstream's .override arguments.
{
  amneziawg-go = import ./pkgs/amneziawg-go {
    inherit lib;
    upstream = prev.amneziawg-go;
  };
  btrbk = import ./pkgs/btrbk {
    inherit lib;
    upstream = prev.btrbk;
  };
  ddns-updater = import ./pkgs/ddns-updater {
    inherit lib;
    upstream = prev.ddns-updater;
  };
  dnsmasq = import ./pkgs/dnsmasq {
    inherit lib;
    upstream = prev.dnsmasq;
  };
  exportarr = import ./pkgs/exportarr {
    inherit lib;
    upstream = prev.exportarr;
  };
  miraclecast = import ./pkgs/miraclecast {
    inherit lib;
    inherit (final) gst_all_1;
    upstream = prev.miraclecast;
  };
  nextcloud-oidc-login = import ./pkgs/nextcloud-oidc-login {
    inherit lib;
    upstream = prev.nextcloud34.packages.apps.oidc_login;
  };
  prowlarr = import ./pkgs/prowlarr {
    inherit lib;
    upstream = prev.prowlarr;
  };
  prometheus-qbittorrent-exporter = import ./pkgs/prometheus-qbittorrent-exporter {
    inherit lib;
    upstream = prev.prometheus-qbittorrent-exporter;
  };
  qbittorrent = import ./pkgs/qbittorrent {
    inherit lib;
    upstream = prev.qbittorrent;
  };
  radarr = import ./pkgs/radarr {
    inherit lib;
    upstream = prev.radarr;
  };
  rauthy = import ./pkgs/rauthy {
    inherit lib;
    upstream = prev.rauthy;
  };
  sonarr = import ./pkgs/sonarr {
    inherit lib;
    upstream = prev.sonarr;
  };
  uxplay = import ./pkgs/uxplay {
    inherit lib;
    upstream = prev.uxplay;
  };
}

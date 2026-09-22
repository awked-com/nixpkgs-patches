# Patch provenance

Each `pkgs/<name>/default.nix` wraps the corresponding package in the locked
Nixpkgs source. `nextcloud-oidc-login` wraps
`nextcloud34.packages.apps.oidc_login`. The lockfile pins Nixpkgs commit
`44a91898084f46797b5fac650c7e8c9ac38c43d4`. Upstream package source and version
metadata remain owned by those recipes; this repository does not vendor the
upstream source trees.

Patches retain existing upstream context, embedded copyright notices,
authorship, commit identifiers, and signed-off-by lines. In particular,
AmneziaWG patches 0001–0004 retain their WireGuard authors and original commit
references; patch 0005 retains Rany Hany's authorship. Patch 0006 contains no
separate author header. Other patch files generally use plain unified diffs and
do not provide complete per-change author or license declarations.

No repository-wide license declaration was present in the source snapshot;
existing notices are preserved.

| Patch directory | Upstream project / Nixpkgs attribute |
| --- | --- |
| amneziawg-go | AmneziaWG Go / `amneziawg-go` |
| btrbk | btrbk / `btrbk` |
| ddns-updater | DDNS Updater / `ddns-updater` |
| dnsmasq | dnsmasq / `dnsmasq` |
| exportarr | Exportarr / `exportarr` |
| miraclecast | MiracleCast / `miraclecast` |
| nextcloud-oidc-login | Nextcloud OIDC Login / `nextcloud34.packages.apps.oidc_login` |
| prometheus-qbittorrent-exporter | qBittorrent exporter / `prometheus-qbittorrent-exporter` |
| prowlarr | Prowlarr / `prowlarr` |
| qbittorrent | qBittorrent / `qbittorrent` |
| radarr | Radarr / `radarr` |
| rauthy | Rauthy / `rauthy` |
| sonarr | Sonarr / `sonarr` |
| uxplay | UxPlay / `uxplay` |

The two trusted-proxy patches use application-specific environment names:
`SONARR_TRUSTED_PROXY` and `PROWLARR_TRUSTED_PROXY`. The UxPlay control-request
patch description states its HLS limitation independently of any deployment.

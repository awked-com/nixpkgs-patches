# Nixpkgs patches

Patches and package wrappers for Nixpkgs, exposed through `overlays.default`
and per-system `packages` outputs.

## Use

Add the input and follow your Nixpkgs input:

```nix
inputs.nixpkgs-patches = {
  url = "github:awked-com/nixpkgs-patches";
  inputs.nixpkgs.follows = "nixpkgs";
};

# In a NixOS module:
nixpkgs.overlays = [ inputs.nixpkgs-patches.overlays.default ];
```

Or build a package directly:

```sh
nix build github:awked-com/nixpkgs-patches#dnsmasq
```

The lockfile pins Nixpkgs; other revisions may require refreshing patches.
Wrappers preserve upstream `.override` arguments, patches, dependencies, and
build options except as listed below. Outputs cover `x86_64-linux`,
`aarch64-linux`, and `aarch64-darwin`, filtered by upstream platform support.
Btrbk is Linux-only because it needs `btrfs-progs`.

## Packages

| Package | Changes |
| --- | --- |
| amneziawg-go | WireGuard fixes for packet headers, handshake allocations and encoding, exact message lengths, timer races, and pooled UDP address lengths. |
| btrbk | Accept full receives published as read-only snapshots only when the received UUID matches the sent stream. |
| ddns-updater | `PUBLICIP_INTERFACE` selects addresses from a named network interface and disables external address discovery. |
| dnsmasq | Refresh timed nftables set entries atomically when DNS answers refresh an address. |
| exportarr | Format IPv6 HTTP listen addresses correctly. |
| miraclecast | External supplicant control, P2P management and addressing, WFD sessions, an in-process GStreamer player, and RTSP bounds. |
| nextcloud-oidc-login | Require the provider account identifier to match the existing Nextcloud account exactly. |
| prometheus-qbittorrent-exporter | Format IPv6 HTTP listen addresses correctly. |
| prowlarr | Trust forwarded headers only from `PROWLARR_TRUSTED_PROXY`. |
| qbittorrent | Use the socket peer for authentication bypass and trusted proxy checks. |
| radarr | Honor literal IP address families independently of prior hostname failures. |
| rauthy | Derive frontend asset versions from source and patches, and support IPv6 metrics listeners. |
| sonarr | Honor literal IP address families and trust forwarded headers only from `SONARR_TRUSTED_PROXY`. |
| uxplay | Optional display ownership hooks, enforcement of disabled HLS, bounded control requests, and validation of PIN pairing. |

`SONARR_TRUSTED_PROXY` and `PROWLARR_TRUSTED_PROXY` each accept one literal IPv4
or IPv6 address and trust one proxy hop. Forwarded headers are disabled when the
variable is absent or invalid; set it when using a reverse proxy.

UxPlay's optional `UXPLAY_DISPLAY_COMMAND` names an executable called with
`acquire uxplay` and `release uxplay`; it runs without a shell. Keep HLS disabled
with `-nh` when relying on the control-request bounds. Enabling HLS also requires
queued nonblocking FCUP output, which these patches do not provide. Miraclecast
exposes `MIRACLECAST_WPA_CONTROL`, `MIRACLECAST_WPA_CLIENT_DIR`, and
`MIRACLECAST_SOCKET_MARK` for integrations; no host-specific values are supplied.

Miraclecast disables reliance on udev tags and adds GStreamer's base plugin.
`nextcloud-oidc-login` wraps `nextcloud34.packages.apps.oidc_login` and removes
the app signature invalidated by patching. Exportarr allows local networking
during macOS builds. Sonarr, Radarr, and Prowlarr retain `doCheck = false`.

## Develop and check

```sh
git ls-files -z '*.nix' | xargs -0 nix fmt -- --check
nix flake check --no-build --all-systems
nix build .#checks.aarch64-darwin.overlay-contract
nix flake check
```

Use the matching system name for the contract build. It checks exported package
settings, patch order, and upstream override arguments. Full flake checks build
supported packages on the current system. Network, display, mount, and
authentication changes also need runtime integration tests.

Keep patches in filename order as `NNNN-description.patch`. Use Quilt against an
unpatched copy of the locked upstream source and refresh without timestamps.

The [overlay](https://github.com/awked-com/overlay) command uses this flake's
locked sources. `nix develop` provides it through the pinned
`awked-com/packages` input:

```sh
nix develop
overlay list
overlay setup dnsmasq
overlay status dnsmasq
overlay select dnsmasq 0001-renew-nftset-element-timeouts.patch
overlay edit dnsmasq src/nftset.c
overlay refresh dnsmasq
```

Use `overlay -C /path/to/nixpkgs-patches` from another directory. Source worktrees
live under `.patch-worktrees/pkgs` and are ignored by Git.

`lib.patchFiles lib directory` returns a directory's numbered patch files in
filename order and rejects invalid patch names. Consumers can reuse it for
additional package overrides.

Retain patch authorship, commit references, and copyright notices. AmneziaWG
patches 0001–0004 retain their WireGuard authors; 0005 names Rany Hany; 0006 has
no author header. Other patches are generally plain diffs without complete
author or license declarations. This repository has no repository-wide license;
upstream source and license metadata remain in the Nixpkgs recipes.

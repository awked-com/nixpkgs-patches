# Nixpkgs patches

Reusable fixes and opt-in integrations layered over Nixpkgs packages. This
repository contains patches, thin package wrappers, and an overlay. It does not
contain system configurations or require another repository maintained by Awked.

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

The lockfile identifies the tested Nixpkgs source. Following a different Nixpkgs
revision may require refreshing patches. Wrappers preserve upstream `.override`
arguments, existing patches, dependencies, and build options, with the explicit
exceptions documented below. Outputs cover x86_64 Linux, aarch64 Linux, and
aarch64 macOS, filtered by each upstream package's platform support. Btrbk is
exposed only on Linux because its `btrfs-progs` dependency requires Linux.

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

The Sonarr and Prowlarr proxy variables each accept one literal IPv4 or IPv6
address. When absent or invalid, forwarded headers are disabled. Only one proxy
hop is trusted. The overlay changes that default, so set the appropriate variable
when using a reverse proxy.

UxPlay's optional `UXPLAY_DISPLAY_COMMAND` names an executable called with
`acquire uxplay` and `release uxplay`; it runs without a shell. Keep HLS disabled
with `-nh` when relying on the control-request bounds. Enabling HLS also requires
queued nonblocking FCUP output, which these patches do not provide. Miraclecast
exposes `MIRACLECAST_WPA_CONTROL`, `MIRACLECAST_WPA_CLIENT_DIR`, and
`MIRACLECAST_SOCKET_MARK` for integrations; no host-specific values are supplied.

The Miraclecast wrapper disables reliance on udev tags and adds the GStreamer
base plugin dependency. The Nextcloud app wrapper removes the original app
signature because patching changes its contents. Exportarr allows local
networking during macOS builds. The Sonarr, Radarr, and Prowlarr wrappers retain
`doCheck = false`; their upstream test suites are not run by those derivations.

## Develop and check

```sh
nix develop
nix flake check --no-build --all-systems
nix build .#checks.aarch64-darwin.overlay-contract
nix flake check
```

Use the matching system name for the contract build. Evaluation checks compare
inherited build settings, ensure local patches are attached after upstream
patches, and exercise preserved package override arguments. Full flake checks
build supported packages on the current system; they do not establish runtime
correctness on all platforms. Network, display, mount, and authentication changes
also need upstream and integration testing appropriate to their behavior.

Keep patches in filename order as `NNNN-description.patch`. Use Quilt against an
unpatched copy of the locked upstream source, refresh without timestamps, and
retain existing authorship and copyright notices. See [PROVENANCE.md](PROVENANCE.md)
for source and licensing boundaries.

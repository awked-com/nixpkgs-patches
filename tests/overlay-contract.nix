{
  lib,
  packages,
  pkgs,
  upstream,
}:
let
  reference =
    name:
    if name == "nextcloud-oidc-login" then
      upstream.nextcloud34.packages.apps.oidc_login
    else if name == "miraclecast" then
      upstream.miraclecast.override { relyUdev = false; }
    else if
      builtins.elem name [
        "sonarr"
        "radarr"
        "prowlarr"
      ]
    then
      upstream.${name} // { doCheck = false; }
    else
      upstream.${name};
  settings =
    package:
    builtins.toJSON (
      lib.genAttrs [
        "nativeBuildInputs"
        "cmakeFlags"
        "doCheck"
        "env"
        "cargoBuildFeatures"
        "cargoCheckFeatures"
      ] (name: package.${name} or null)
    );
  contracts = lib.mapAttrs (
    name: package:
    let
      original = reference name;
      localPatches = import ../pkgs/lib/patches.nix lib (../pkgs + "/${name}/patches");
    in
    settings package == settings original
    && localPatches != [ ]
    && package.patches == (original.patches or [ ]) ++ localPatches
  ) packages;
  headlessOptions = {
    guiSupport = false;
    webuiSupport = false;
    trackerSearch = false;
  };
  headless = pkgs.qbittorrent.override headlessOptions;
  upstreamHeadless = upstream.qbittorrent.override headlessOptions;
  overrides =
    lib.optionalAttrs (builtins.hasAttr "qbittorrent" packages) {
      qbittorrent-options =
        headless.pname == upstreamHeadless.pname
        && headless.cmakeFlags == upstreamHeadless.cmakeFlags
        && headless.buildInputs == upstreamHeadless.buildInputs
        && headless.qtWrapperArgs == upstreamHeadless.qtWrapperArgs
        && headless.patches == pkgs.qbittorrent.patches;
    }
    //
      lib.mapAttrs'
        (
          name: _:
          let
            package = pkgs.${name}.override { withFFmpeg = false; };
            original = upstream.${name}.override { withFFmpeg = false; };
          in
          lib.nameValuePair "${name}-options" (
            package.postInstall == original.postInstall && package.patches == pkgs.${name}.patches
          )
        )
        (
          lib.filterAttrs (
            name: _:
            builtins.elem name [
              "sonarr"
              "radarr"
            ]
          ) packages
        );
  failures = builtins.attrNames (lib.filterAttrs (_: passes: !passes) (contracts // overrides));
in
assert lib.assertMsg (
  failures == [ ]
) "Package contract failures: ${lib.concatStringsSep ", " failures}";
pkgs.runCommand "overlay-contract" { } ''
  mkdir -p "$out"
  printf '%s\n' 'Package defaults, patch attachment, and override interfaces evaluated.' > "$out/result"
''

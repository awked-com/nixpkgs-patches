{ lib, upstream }:

upstream.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ import ../lib/patches.nix lib ./patches;
  # Patching invalidates the upstream app signature.
  postPatch = (old.postPatch or "") + ''
    rm -f appinfo/signature.json
  '';
})

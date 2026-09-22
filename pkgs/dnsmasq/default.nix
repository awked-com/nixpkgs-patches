{ lib, upstream }:

upstream.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ import ../lib/patches.nix lib ./patches;
})

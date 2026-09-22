{
  lib,
  upstream,
  gst_all_1,
}:

(upstream.override { relyUdev = false; }).overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ import ../lib/patches.nix lib ./patches;
  buildInputs = (old.buildInputs or [ ]) ++ [
    gst_all_1.gst-plugins-base
  ];
})

{
  lib,
  upstream,
}:

upstream.overrideAttrs (
  old:
  let
    patches = (old.patches or [ ]) ++ import ../lib/patches.nix lib ./patches;
    uiVersion = builtins.hashString "sha256" (
      builtins.toJSON {
        src = toString old.src;
        patches = map builtins.readFile patches;
      }
    );
  in
  {
    inherit patches;

    postPatch = (old.postPatch or "") + ''
      substituteInPlace frontend/svelte.config.js \
        --replace-fail '@rauthyUiVersion@' '${uiVersion}'
    '';
  }
)

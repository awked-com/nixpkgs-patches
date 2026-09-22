lib: directory:

let
  entries = if builtins.pathExists directory then builtins.readDir directory else { };
  names = lib.filter (name: entries.${name} == "regular" && lib.hasSuffix ".patch" name) (
    builtins.attrNames entries
  );
  patchPath =
    name:
    if builtins.match "[0-9]{4}-[a-zA-Z0-9][a-zA-Z0-9._+-]*\\.patch" name == null then
      throw "Patch filenames must use NNNN-description.patch: ${toString directory}/${name}"
    else
      directory + "/${name}";
in
map patchPath names

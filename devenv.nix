{
  pkgs,
  lib,
  ...
}: {
  cachix.enable = false;
  packages = with pkgs; [libGL libx11 libxext libxrandr];
  env = {
    PYTHONNOUSERSITE = "1";
    UV_PYTHON = "3.12";
    UV_PYTHON_PREFERENCE = "only-system";
    UV_PYTHON_DOWNLOADS = "never";
    LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib pkgs.zlib pkgs.freetype pkgs.fontconfig pkgs.libGL pkgs.libx11 pkgs.libxext pkgs.libxrandr];
  };
  enterShell =
    (import (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/NostraDavid/nixcfg/cb2423e55f4a7ee010d33a649ddf0488338baa42/nix/system-tools.nix";
        sha256 = "7d2abe646d9389e296c5e1cafa0b63dd52e9821c58037d9dd8faef90124104e2";
      }) (pkgs // {python312 = (pkgs.python312.withPackages (ps: [ps.tkinter])) // {inherit (pkgs.python312) version;};}) [
        {
          attr = "python312";
          check = ''"1" -c "import tkinter, _tkinter" >/dev/null 2>&1'';
        }
        "just"
        {
          attr = "uv";
          series = "0";
          also = ["uvx"];
        }
      ])
    + ''
      unset PYTHONHOME _PYTHON_SYSCONFIGDATA_NAME
      # uv launches the base interpreter directly; carry the selected interpreter's Tk modules into its venv.
      export PYTHONPATH="$(python3 -c 'from pathlib import Path; import os, tkinter, _tkinter; print(os.pathsep.join(dict.fromkeys(map(str, [Path(tkinter.__file__).parent.parent, Path(_tkinter.__file__).parent]))))')"
    '';
}

{
  pkgs,
  lib,
  ...
}: {
  cachix.enable = false;
  packages = with pkgs; [
    just
    uv
    python312
    libGL
    libx11
    libxext
    libxrandr
  ];
  env = {
    PYTHONNOUSERSITE = "1";
    PYTHONPATH = "${pkgs.python312Packages.tkinter}/${pkgs.python312.sitePackages}";
    UV_PYTHON = "3.12";
    UV_PYTHON_PREFERENCE = "only-system";
    UV_PYTHON_DOWNLOADS = "never";
    LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib pkgs.zlib pkgs.freetype pkgs.fontconfig pkgs.libGL pkgs.libx11 pkgs.libxext pkgs.libxrandr];
  };
  enterShell = ''
    unset PYTHONHOME _PYTHON_SYSCONFIGDATA_NAME
  '';
}

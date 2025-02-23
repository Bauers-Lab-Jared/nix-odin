{
  lib,
  fetchFromGitHub,
  callPackage,
  static ? true,
  ...
}: let
  src = fetchFromGitHub {
    owner = "floooh";
    repo = "sokol-odin";
    rev = "b87b77b1b888d1e2f0c02d38137181fb0174fe57";
    hash = "sha256-SEjxZZGsj8KuBDaG+eNHGkZnLhQNjTDwVGimdoWASQ0=";
  };
  mkSokolLib = name: {
    stdenv,
    libGLU,
    mesa,
    xorg,
    alsa-lib,
  }:
    stdenv.mkDerivation (finalAttrs: {
      inherit src;
      pname = "sokol-${name}";
      version = "0";
      sourceRoot = "${src.name}/sokol/${name}";

      propagatedBuildInputs = [
        libGLU
        mesa
        xorg.libX11
        xorg.libXi
        xorg.libXcursor
        alsa-lib
      ];

      buildPhase = ''
        runHook preBuild

        lsrc=sokol_${name}
        backend=SOKOL_GLCORE

        ${
          if static
          then
            # bash
            ''
              cc -pthread -c -O2 -DNDEBUG -DIMPL -D$backend ../c/$lsrc.c
              ar rcs release.a $lsrc.o

              cc -pthread -c -g -DIMPL -D$backend ../c/$lsrc.c
              ar rcs debug.a $lsrc.o
            ''
          else
            #bash
            ''
              cc -pthread -shared -O2 -fPIC -DNDEBUG -DIMPL -D$backend -o release.so ../c/$lsrc.c

              cc -pthread -shared -g -fPIC -DIMPL -D$backend -o debug.so ../c/$lsrc.c
            ''
        }

        rm *.o

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/lib"
        mkdir -p "$out/include"

        sed -i 's/^\(import .*"\)\.\.\/\([^"]*\)"/\1lib:sokol\/\2"/' *.odin
        sed -i "s/sokol_\([^_]*\)_linux_x64_gl_\([^._]*\).\([^\"]*\)/system:sokol_\1_\2/" *.odin

        cp *.odin "$out/include"

        ${
          if static
          then
            # bash
            ''
              mv release.a "$out/lib/libsokol_${name}_release.a"
              mv debug.a "$out/lib/libsokol_${name}_debug.a"
            ''
          else
            # bash
            ''
              mv release.so "$out/lib/libsokol_${name}_release.so"
              mv debug.so "$out/lib/libsokol_${name}_debug.so"
            ''
        }

        runHook postInstall
      '';
    });

  sokolModules = [
    "log"
    "gfx"
    "app"
    "glue"
    "time"
    "audio"
    "debugtext"
    "shape"
    "gl"
  ];
in
  lib.genAttrs sokolModules (moduleName:
    callPackage (mkSokolLib moduleName) {})

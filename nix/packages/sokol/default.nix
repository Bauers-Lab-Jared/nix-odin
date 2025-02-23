{
  lib,
  fetchFromGitHub,
  callPackage,
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

      outputs = ["out"];

      buildPhase = ''
        runHook preBuild

        lsrc=sokol_${name}
        backend=SOKOL_GLCORE

        # static
        cc -pthread -c -O2 -DNDEBUG -DIMPL -D$backend ../c/$lsrc.c
        ar rcs release.a $lsrc.o
        # shared
        cc -pthread -shared -O2 -fPIC -DNDEBUG -DIMPL -D$backend -o release.so ../c/$lsrc.c

        # static
        cc -pthread -c -g -DIMPL -D$backend ../c/$lsrc.c
        ar rcs debug.a $lsrc.o
        # shared
        cc -pthread -shared -g -fPIC -DIMPL -D$backend -o debug.so ../c/$lsrc.c

        rm *.o

        runHook postBuild
      '';

      installPhase = ''
                runHook preInstall

                rDst="$out/lib/libsokol_${name}"
                dDst="$out/lib/libsokol_${name}_debug"

                mkdir -p "$out/lib/pkgconfig"
                mkdir -p "$out/include"

                sed -i 's/^\(import .*"\)\.\.\/\([^"]*\)"/\1lib:sokol\/\2"/' *.odin
                sed -i "s/sokol_\([^_]*\)_linux_x64_gl_\([^._]*\).\([^\"]*\)/system:sokol_\1/" *.odin

                cp *.odin "$out/include"

        #        mv release.a "''${rDst}a"
        #        mv debug.a "''${dDst}a"
                mv release.so "''${rDst}.so"
        #        mv debug.so "''${dDst}so"

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

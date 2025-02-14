{
  stdenv,
  fetchFromGitHub,
  lib,
  libGLU,
  mesa,
  xorg,
  alsa-lib,
}:
stdenv.mkDerivation {
  pname = "sokol-odin";
  version = "0";
  src = fetchFromGitHub {
    owner = "floooh";
    repo = "sokol-odin";
    rev = "b87b77b1b888d1e2f0c02d38137181fb0174fe57";
    hash = "sha256-SEjxZZGsj8KuBDaG+eNHGkZnLhQNjTDwVGimdoWASQ0=";
  };

  unpackPhase = "";
  configurePhase = ":";
  preInstall = "";
  postInstall = "";
  addonInfo = null;

  buildInputs = [
    libGLU
    mesa
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    alsa-lib
  ];

  buildPhase = ''
    runHook preBuild

    cd sokol
    ./build_clibs_linux.sh
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    target=$out
    mkdir -p $target
    cp -r ./sokol/** $target

    runHook postInstall
  '';
}

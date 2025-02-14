{
  stdenv,
  fetchFromGitHub,
  lib,
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
  buildPhase = ":";
  preInstall = "";
  postInstall = "";
  addonInfo = null;

  installPhase = ''
    runHook preInstall

    target=$out
    mkdir -p $target
    cp -r ./sokol/** $target

    runHook postInstall
  '';
}

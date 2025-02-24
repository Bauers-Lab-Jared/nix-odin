{
  lib,
  fetchFromGitHub,
  stdenv,
  autoPatchelfHook,
  ...
}:
stdenv.mkDerivation {
  pname = "sokol-shdc";
  version = "0";

  src = fetchFromGitHub {
    owner = "floooh";
    repo = "sokol-tools-bin";
    rev = "339ff0314f19414c248cd540b7c72de1873f3a4b";
    hash = "sha256-VkDdHsEpTII75vstFATc505d8SJ6XuKPqd3hS3txuJY=";
  };

  nativeBuildInputs = [autoPatchelfHook];

  installPhase = ''
    runHook preInstall
    install -m755 -D ./bin/linux/sokol-shdc $out/bin/sokol-shdc
    runHook postInstall
  '';
}

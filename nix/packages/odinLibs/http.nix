{
  stdenv,
  fetchFromGitHub,
  lib,
}: let
  libName = lib.removeSuffix ".nix" (baseNameOf (toString __curPos.file));
in
  stdenv.mkDerivation {
    pname = "odin-http";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "laytan";
      repo = "odin-http";
      rev = "41a5cb2cf5a1d2be0a19806661f01c7f1ee133be";
      hash = "sha256-xf/y+97pAxiE8t4CvzJyBAHbDkkpCys1/70uZK3SDMI=";
    };

    unpackPhase = "";
    configurePhase = ":";
    buildPhase = ":";
    preInstall = "";
    postInstall = "";
    addonInfo = null;

    installPhase = ''
      runHook preInstall

      target=$out/include
      mkdir -p $target
      cp -r ./ $target

      runHook postInstall
    '';
  }

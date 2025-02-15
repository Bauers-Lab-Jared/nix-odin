{
  stdenv,
  fetchFromGitHub,
  lib,
}: let
  libName = lib.removeSuffix ".nix" (baseNameOf (toString __curPos.file));
in
  stdenv.mkDerivation {
    pname = "odin-waffle";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "Bauers-Lab-Jared";
      repo = "odin-waffle";
      rev = "e821ee9efc45c87308d58a965fc3800e7c2bcd4f";
      hash = "sha256-X8lOL6UsL35o5/d9WQSbJE8gz3EUhu/EOBS9mT9b6Qk=";
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

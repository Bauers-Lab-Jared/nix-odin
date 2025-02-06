{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "WaffleLib";
  version = "0.1";
  src = ./src/main;

  unpackPhase = "";
  configurePhase = ":";
  buildPhase = ":";
  preInstall = "";
  postInstall = "";
  addonInfo = null;

  installPhase = ''
    runHook preInstall

    target=$out/
    #mkdir -p $out/
    cp -r ./WaffleLib/ $target

    runHook postInstall
  '';
}

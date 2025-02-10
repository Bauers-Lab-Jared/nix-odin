{odinConfig}: {stdenv, ...}:
stdenv.mkDerivation {
  inherit
    (odinConfig)
    pname
    version
    src
    nativeBuildInputs
    buildInputs
    ;

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    ${odinConfig.cliCmd.build}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/resources
    cp -r $src/resources/ $out

    runHook postInstall
  '';
}

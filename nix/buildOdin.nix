{odinConfig}: args @ {stdenv, ...}: let
  fromArgs = name: builtins.getAttr name args;
in
  stdenv.mkDerivation {
    nativeBuildInputs = map fromArgs odinConfig.nativeBuildInputs;
    buildInputs = map fromArgs odinConfig.buildInputs;

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/bin
      ${odinConfig.cli.build.cmd}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/resources
      cp -r $src/resources/ $out

      runHook postInstall
    '';
  }
  // (map fromArgs
    [
      "pname"
      "version"
      "src"
    ])

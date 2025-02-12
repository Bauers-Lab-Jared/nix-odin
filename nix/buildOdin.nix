{odinConfig}: projConfig: let
  cfg = odinConfig projConfig;
in
  args @ {stdenv, ...}: let
    fromArgs = name: builtins.getAttr name args;
  in
    stdenv.mkDerivation {
      nativeBuildInputs = map fromArgs cfg.nativeBuildInputs;
      buildInputs = map fromArgs cfg.buildInputs;

      buildPhase = ''
        runHook preBuild

        mkdir -p $out/bin
        ${cfg.cli.build.cmd}

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

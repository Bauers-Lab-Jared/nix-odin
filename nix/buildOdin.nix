{
  lib,
  pkgs,
}: projConfig: let
  cfg = lib.odinConfig pkgs projConfig;

  fArgs = let
    allInputs = lib.unique (cfg.nativeBuildInputs ++ cfg.buildInputs);
  in
    lib.genAttrs (["stdenv"] ++ allInputs) (n: false);

  f = args @ {stdenv, ...}: let
    fromArgs = name: builtins.getAttr name args;
  in
    stdenv.mkDerivation {
      inherit
        (cfg)
        pname
        version
        src
        odinConfig
        ;
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
    };
in
  lib.setFunctionArgs f fArgs

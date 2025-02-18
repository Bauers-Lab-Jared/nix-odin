{pkgs}: projConfig: let
  inherit (pkgs) odinConfig lib;
  cfg = odinConfig projConfig;

  getInputPaths = inputStrs: map (s: lib.splitString "." s) inputStrs;
  nativeBuildInputPaths = getInputPaths (lib.unique cfg.nativeBuildInputStrs);
  buildInputPaths = getInputPaths (lib.unique cfg.buildInputStrs);
  allInputPaths = lib.unique (nativeBuildInputPaths ++ buildInputPaths);
  allInputArgs = map (p: builtins.elemAt p 0) allInputPaths;
  fArgs = lib.genAttrs (["stdenv"] ++ allInputArgs) (n: false);

  f = args @ {stdenv, ...}: let
    fromArgs = attrPath: lib.getAttrFromPath attrPath args;
  in
    stdenv.mkDerivation rec {
      inherit (cfg) pname version src;
      passthru = {
        inherit cfg;
      };
      nativeBuildInputs = (map fromArgs nativeBuildInputPaths) ++ [cfg.libs.odinLib];
      buildInputs = map fromArgs buildInputPaths;

      unpackPhase = ''
        mkdir -p ./src/main
        mkdir -p ./src/lib

        cp -r -L $src/** ./src/main
        cp -r -L ${cfg.libs.odinLib}/** ./src/lib
      '';

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

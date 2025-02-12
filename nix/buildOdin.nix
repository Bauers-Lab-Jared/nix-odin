{pkgs}: projConfig: let
  inherit (pkgs) odinLibs lib;

  odinConfig = configModules: let
    modules =
      [
        ({...}: {config._module.args = {inherit pkgs odinLibs;};})
        ./modules
      ]
      ++ configModules;
  in
    (lib.evalModules {inherit modules;}).config;

  cfg = odinConfig projConfig;

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

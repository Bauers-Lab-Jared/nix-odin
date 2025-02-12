{pkgs}: projConfig: let
  inherit (pkgs) odinLibs;
  odinConfig = configModules: let
    modules =
      [
        ({...}: {config._module.args = {inherit pkgs odinLibs;};})
        ./modules
      ]
      ++ configModules;
  in
    (pkgs.lib.evalModules {inherit modules;}).config;
  cfg = odinConfig projConfig;
in
  args @ {stdenv, ...}: let
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
    }

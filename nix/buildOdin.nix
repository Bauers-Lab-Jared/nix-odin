{pkgs}: projConfig: let
  inherit (pkgs) odinConfig lib;
  cfg = odinConfig projConfig;

  fArgs = let
    allInputs = lib.unique (cfg.nativeBuildInputs ++ cfg.buildInputs);
  in
    lib.genAttrs (["which" "stdenv"] ++ allInputs) (n: false);

  f = args @ {
    stdenv,
    which,
    ...
  }: let
    fromArgs = name: builtins.getAttr name args;
  in
    stdenv.mkDerivation rec {
      inherit (cfg) pname version src;
      passthru = {
        inherit cfg;
      };
      nativeBuildInputs = (map fromArgs cfg.nativeBuildInputs) ++ [cfg.libs.odinLib which];
      buildInputs = (map fromArgs cfg.buildInputs) ++ [pkgs.sokol-odin];

      LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${
        pkgs.lib.makeLibraryPath buildInputs
      }";

      buildPhase = ''
        runHook preBuild

        which ld
        which odin

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

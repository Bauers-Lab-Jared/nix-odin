{pkgs}: projConfig: let
  inherit (pkgs) odinConfig lib;
  cfg = odinConfig projConfig;
  odinLib = cfg.libs.odinLib pkgs.odinLibs;

  getInputPaths = inputStrs: map (s: lib.splitString "." s) inputStrs;
  nativeBuildInputPaths = getInputPaths (lib.unique cfg.nativeBuildInputStrs);
  buildInputPaths = getInputPaths (lib.unique cfg.buildInputStrs);
  allInputPaths = lib.unique (nativeBuildInputPaths ++ buildInputPaths);
  allInputArgs = map (p: builtins.elemAt p 0) allInputPaths;
  fArgs = lib.genAttrs (["tree" "stdenv" "sokol-odin"] ++ allInputArgs) (n: false);

  f = args @ {
    stdenv,
    tree,
    sokol-odin,
    ...
  }: let
    fromArgs = attrPath: lib.getAttrFromPath attrPath args;
  in
    stdenv.mkDerivation {
      inherit (cfg) pname version src;
      passthru = {
        inherit cfg;
      };
      nativeBuildInputs = (map fromArgs nativeBuildInputPaths) ++ [odinLib tree];
      buildInputs =
        (map fromArgs buildInputPaths)
        ++ [
          sokol-odin.app
          sokol-odin.gfx
          sokol-odin.glue
          sokol-odin.gl
          sokol-odin.log
        ];

      unpackPhase = ''
        mkdir -p ./src/main
        mkdir -p ./src/lib/sokol
        mkdir -p ./src/lib/sokol/app
        mkdir -p ./src/lib/sokol/gfx
        mkdir -p ./src/lib/sokol/glue
        mkdir -p ./src/lib/sokol/gl
        mkdir -p ./src/lib/sokol/log

        cp -r -L $src/* ./src/main
        cp -r -L ${sokol-odin.app}/include/*.odin ./src/lib/sokol/app
        cp -r -L ${sokol-odin.gfx}/include/*.odin ./src/lib/sokol/gfx
        cp -r -L ${sokol-odin.glue}/include/*.odin ./src/lib/sokol/glue
        cp -r -L ${sokol-odin.gl}/include/*.odin ./src/lib/sokol/gl
        cp -r -L ${sokol-odin.log}/include/*.odin ./src/lib/sokol/log

        cp -r -L ${sokol-odin.app}/include/*a ./src/lib
        cp -r -L ${sokol-odin.gfx}/include/*a ./src/lib
        cp -r -L ${sokol-odin.glue}/include/*a ./src/lib
        cp -r -L ${sokol-odin.gl}/include/*a ./src/lib
        cp -r -L ${sokol-odin.log}/include/*a ./src/lib

        chmod -R u+w -- ./

        tree
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

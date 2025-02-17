{
  lib,
  lname,
}: {
  stdenv,
  libGLU,
  mesa,
  xorg,
  alsa-lib,
  sokol-odin-src,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = lname;
  version = "0";
  src = sokol-odin-src;
  sourceRoot = "${src.name}/sokol/${pname}";

  propagatedBuildInputs = [
    libGLU
    mesa
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    alsa-lib
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildPhase = ''
    runHook preBuild

    lsrc=sokol_${pname}
    backend=SOKOL_GLCORE

    # static
    cc -pthread -c -O2 -DNDEBUG -DIMPL -D$backend ../c/$lsrc.c
    ar rcs release.a $lsrc.o
    # shared
    cc -pthread -shared -O2 -fPIC -DNDEBUG -DIMPL -D$backend -o release.so ../c/$lsrc.c

    # static
    cc -pthread -c -g -DIMPL -D$backend ../c/$lsrc.c
    ar rcs debug.a $lsrc.o
    # shared
    cc -pthread -shared -g -fPIC -DIMPL -D$backend -o debug.so ../c/$lsrc.c

    rm *.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rDst="$out/lib/sokol_${pname}_release"
    dDst="$out/lib/sokol_${pname}_debug"
    rLink="$out/include/sokol_gl_linux_x64_gl_release"
    dLink="$out/include/sokol_gl_linux_x64_gl_debug"

    mkdir -p "$out/lib/pkgconfig"
    mkdir -p "$out/include"

    SOKOL_DEPS="sokol_${pname} \
    $(sed -n 's/^import .*"\.\.\/\([^"]*\)"/\1/p' *.odin | sed 's/\(.*\)\n/\1 /')"

    sed -i 's/^\(import .*"\)\.\.\/\([^"]*\)"/\1lib:sokol\/\2"/' *.odin
    sed -i "s:sokol_\([^_]*\)_linux_x64_gl_\([^._]*\).:\.\.\/lib\/sokol_\1_\2.:" *.odin

    echo "prefix=$prefix \
    exec_prefix=$exec_prefix \
    libdir=$libdir \
    includedir=$includedir \
     \
    Name: sokol_${pname}\
    Description: The ${pname} module from sokol-odin \
    Version: 0 \
    Requires: $SOKOL_DEPS \
    Cflags: -I''${includedir} \
    Libs: -L''${libdir} -lsokol_${pname}" > "$out/lib/pkgconfig/sokol_${pname}.pc.in"

    cp *.odin "$out/include"

    mv release.a $rDst.a
    mv debug.a $dDst.a
    mv release.so $rDst.so
    mv debug.so $dDst.so

    #echo -n " $out" >> $out/nix-support/propagated-build-inputs

    #ln -s $rDst.a $rLink.a
    #ln -s $dDst.a $dLink.a
    #ln -s $rDst.so $rLink.so
    #ln -s $dDst.so $dLink.so

    runHook postInstall
  '';

  meta = {
    pkgConfigModules = ["sokol_${pname}"];
    platforms = lib.platforms.unix;
  };
}

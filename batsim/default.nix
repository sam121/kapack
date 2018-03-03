{ stdenv, fetchurl, cmake, simgrid_batsim, boost,
gmp, rapidjson, openssl, redox, hiredis, libev, cppzmq, zeromq
}:

stdenv.mkDerivation rec {
  name = "batsim";
  version = "2.0.0";

  src = fetchurl {
    url = "https://gitlab.inria.fr/batsim/batsim/repository/v${version}/archive.tar.gz";
    sha256 = "1r5yfj984xbzlgv5zzai2w19z174s7j52nkdzfsgfqqrzzz5g3r2";
  };

  nativeBuildInputs= [ simgrid_batsim  boost  gmp  rapidjson openssl redox
  hiredis libev cppzmq zeromq cmake ];

  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Debug"];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A batch scheduler simulator with a focus on realism that facilitates comparison.";
    homepage    = "https://github.com/oar-team/batsim";
    platforms   = platforms.unix;

    longDescription = ''
      Batsim is a Batch Scheduler Simulator that uses SimGrid as the
      platform simulator.
    '';
  };
}

{pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixos-17.03.tar.gz) {} }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);
  #ocamlCallPackage = pkgs.ocamlPackages.callPackageWith (pkgs // pkgs.xlibs // self);
  self = rec {
    simgrid_batsim = callPackage ./simgrid/batsim.nix { };
    boost_gcc6 = pkgs.boost.overrideDerivation (oldAttrs: rec {
      nativeBuildInputs = pkgs.gcc6;
    });
    batsim = callPackage ./batsim { };
    batsimTests = callPackage ./batsim/tests.nix { };
    redox = callPackage ./redox { };
    rapidjson = callPackage ./rapidjson { };
    interval_set = callPackage ./interval-set { };
    evalys = callPackage ./evalys { inherit interval_set; };
    execo = callPackage ./execo { };
    obandit = pkgs.ocamlPackages.callPackage ./obandit { };
    zymake = pkgs.ocamlPackages.callPackage ./zymake { };
    ocs = pkgs.ocamlPackages.callPackage ./ocs { inherit obandit; };
    evalysEnv = pkgs.stdenv.mkDerivation {
      name = "evalysEnv";
      buildInputs = [ pkgs.python3 pkgs.python35Packages.matplotlib pkgs.python35Packages.ipython evalys  ];
      shellHook = ''
        ipython3 -i -c "import evalys;import matplotlib;matplotlib.use('Qt5Agg');from matplotlib import pyplot as plt"
      '';
    };
    execoEnv = pkgs.stdenv.mkDerivation {
      name = "execoEnv";
      buildInputs = [ pkgs.python3 pkgs.python35Packages.ipython execo  ];
      shellHook = ''
        ipython3 -i -c "import execo"
      '';
    };
  };
in
  self

{ stdenv }:
stdenv.mkDerivation rec {
  name = "keywind";
  version = "1.0";

  src = ./theme/keywind;

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out
    cp -a login $out
  '';
}
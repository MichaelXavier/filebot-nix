{ pkgs ? import <nixpkgs> { } }:

let
  version = "5.0.3";

  tarball = pkgs.fetchurl {
    url =
      "https://get.filebot.net/filebot/FileBot_${version}/FileBot_${version}-portable.tar.xz";
    sha256 = "sha256-8FTmR+ztR2ugPcgHvfwyh9yfxPiUJdeAVvjjl5cQCy0=";
  };

  jre = pkgs.openjdk11_headless;
in
pkgs.stdenv.mkDerivation rec {
  name = "filebot-${version}";
  inherit version;

  src = tarball;

  buildInputs = [
    pkgs.chromaprint
    pkgs.fontconfig
    pkgs.libmediainfo
    pkgs.libzen
    jre
    pkgs.makeWrapper
  ];

  unpackPhase = ''
    mkdir source
    cd source
    tar xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin/data
    rm filebot.sh
    cp ${./filebot.sh} filebot
    rm -f reinstall-filebot.sh update-filebot.sh
    cp -R jar lib filebot $out/bin
    chmod +x $out/bin/filebot
    wrapProgram $out/bin/filebot \
      --prefix PATH : "${pkgs.lib.makeBinPath [ jre ]}" \
      --set JAVA_HOME "${jre}"
  '';
}

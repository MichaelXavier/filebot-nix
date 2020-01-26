{ stdenv
, fetchurl
, pkgs
}:
#TODO: runtime deps for java and such
# APP_DATA?

#TODO: check if this is idiomatic
let
  version = "4.8.5";

  tarball = fetchurl {
    url    = "https://get.filebot.net/filebot/FileBot_${version}/FileBot_${version}-portable.tar.xz";
    sha256 = "1c2a97rkv57cvy4arnmw9f3zdvxwb5zfvr9iqgpn9rkda00f2hy8";
  };
in
stdenv.mkDerivation rec {
  name    = "filebot-${version}";
  inherit version;

  src = tarball;

  buildInputs = [
    pkgs.chromaprint
    pkgs.fontconfig
    pkgs.openjfx12 # not there for some reason?
    pkgs.libmediainfo
    pkgs.libzen
    pkgs.jre_headless
    pkgs.makeWrapper
    #TODO: drop these?
    pkgs.coreutils
    pkgs.which
  ];

  #TODO: this isn't done in https://github.com/NixOS/nixpkgs/blob/62d86db572901a960838d4d5acadc039b207cfef/pkgs/servers/search/elasticsearch/6.x.nix#L57
  # deps from here, missing some https://aur.archlinux.org/packages/filebot/
  # propagatedBuldInputs = [
  #   pkgs.chromaprint
  #   pkgs.fontconfig
  #   pkgs.openjfx12 # not there for some reason?
  #   pkgs.libmediainfo
  #   pkgs.libzen
  #   pkgs.jre_headless
  # ];

  # don't cd away
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin/data
    rm filebot.sh
    cp ${./filebot.sh} filebot
    rm -f reinstall-filebot.sh update-filebot.sh
    cp -R jar lib filebot $out/bin
    chmod +x $out/bin/filebot
    wrapProgram $out/bin/filebot \
      --prefix PATH : "${stdenv.lib.makeBinPath [ pkgs.jre_headless ]}" \
      --set JAVA_HOME "${pkgs.jre_headless}"
  '';
}

{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "andiru-zsh-theme";
  version = "1.0.0";

  src = fetchzip {
    url = "https://gist.github.com/andregoetz/bc593180258070f8024e28e6570fee3d/archive/8639aa5d4f4353b0ed031ec7f7def42f4d4cdc28.zip";
    hash = "sha256-2EjHra9dFcsnkVsaLr2OD9maxmFGVgb2mATF7/eUfN4=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh/themes
    cp andiru.zsh-theme $out/share/zsh/themes
  '';
}

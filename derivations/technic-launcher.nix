{ lib
, stdenv
, fetchurl
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, libarchive
, icoutils
, jre8 # newer version might be needed for newer modpacks
, curl
, libpulseaudio
, systemd
, alsa-lib
, flite ? null
, libXxf86vm ? null
, libGL ? null
}:

let
  major-version = "4";
  sub-version = "822";

  desktopItem = makeDesktopItem {
    name = "technic-launcher";
    exec = "technic-launcher";
    icon = "technic-launcher";
    comment = "Official Technic Launcher";
    desktopName = "Technic Launcher";
    categories = [ "Game" ];
  };

  # from minecraft package
  envLibPath = lib.makeLibraryPath [
    curl
    libpulseaudio
    systemd
    alsa-lib # needed for narrator
    flite # needed for narrator
    libXxf86vm # needed only for versions <1.13
    libGL # needed only when mojang java runtime doesn't work
  ];
in
stdenv.mkDerivation rec {
  pname = "technic-launcher";
  version = major-version + "." + sub-version;

  src = fetchurl {
    url = "https://launcher.technicpack.net/launcher${major-version}/${sub-version}/TechnicLauncher.jar";
    hash = "sha256-CjLaz/SBYyKThRHZbw0EP3sqzaPDrVcKN20qkhY6jKo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];
  buildInputs = [ libarchive icoutils ];

  dontConfigure = true;
  dontBuild = true;

  preInstall = ''
    bsdtar -xf ${src} net/technicpack/launcher/resources/icon.ico
    icotool -x "net/technicpack/launcher/resources/icon.ico" -o .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java/${pname}
    cp ${src} $out/share/java/${pname}/technic-launcher.jar

    for size in 16 32 48 64; do
      install -D -m644 "icon_"?"_"$size"x"$size"x32.png" \
      "$out/share/icons/hicolor/"$size"x"$size"/apps/technic-launcher.png"
    done

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${jre8}/bin/java $out/bin/technic-launcher \
      --add-flags "-jar $out/share/java/${pname}/technic-launcher.jar" \
      --prefix LD_LIBRARY_PATH : ${envLibPath} \
      --prefix PATH : ${lib.makeBinPath [ jre8 ]} \
      --set JAVA_HOME ${lib.getBin jre8} \
      --chdir /tmp
  '';

  desktopItems = [ desktopItem ];
}

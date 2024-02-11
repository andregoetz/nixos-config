{ lib, stdenv
, fetchurl
, libarchive
, icoutils
, nixosTests
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, wrapGAppsHook
, gobject-introspection
, jre8
, xorg
, zlib
, nss
, nspr
, fontconfig
, pango
, cairo
, expat
, alsa-lib
, cups
, dbus
, atk
, gtk3-x11
, gtk2-x11
, gdk-pixbuf
, glib
, curl
, freetype
, libpulseaudio
, libuuid
, systemd
, libXxf86vm
, mesa
, flite ? null
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

  envLibPath = lib.makeLibraryPath [
    curl
    libpulseaudio
    systemd
    jre8
    mesa
    libXxf86vm # needed for versions <1.13
    alsa-lib # needed for narrator
    flite # needed for narrator
  ];

  libPath = lib.makeLibraryPath ([
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    pango
    gtk3-x11
    gtk2-x11
    nspr
    nss
    stdenv.cc.cc
    zlib
    libuuid
  ] ++
  (with xorg; [
    libX11
    libxcb
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libXScrnSaver
  ]));
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
      --set JAVA_HOME ${lib.getBin jre8}
    patchelf \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --set-rpath '$ORIGIN/'":${libPath}" \
      $out/bin/technic-launcher
  '';

  desktopItems = [ desktopItem ];
}

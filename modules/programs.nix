{ pkgs, lib, config, ... }:

let
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config.allowUnfree = true; };
  electron-mail-fix = import (fetchTarball https://github.com/Princemachiavelli/nixpkgs/archive/master.tar.gz) { config.allowUnfree = true; };
  technic-launcher = pkgs.callPackage ../derivations/technic-launcher.nix { };

  vscode-settings = import ./vscode.nix { unstable = unstable; };
  unfree-predicate = [
      "lunar-client-3.1.0"
      "steam"
      "steam-original"
      "steam-run"
  ] ++ vscode-settings.unfree-predicate;
in
{
  # unfree predicate
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree-predicate;
  };

  # overlays
  nixpkgs.overlays = [
    (final: prev: {
      rnote = unstable.rnote;
      lunar-client = unstable.lunar-client;
      tutanota-desktop = unstable.tutanota-desktop;
      electron-mail = electron-mail-fix.electron-mail;
    })
    vscode-settings.overlay
  ];

  # packages installed in system profile
  environment.systemPackages = with pkgs; [
    xclip
    zoxide
    encfs
    ntfs3g
    evince
    ffmpegthumbnailer
    webp-pixbuf-loader
    gnome-epub-thumbnailer
    chroma
    ripgrep
    ripgrep-all
    sweet-nova
    just
    nixpkgs-fmt
    accountsservice
    gnome.seahorse
  ];

  # andiru packages
  users.users.andiru.packages = with pkgs; ([
    # system
    vlc
    mpv
    ffmpeg
    neofetch
    yt-dlp
    gnome.gnome-disk-utility
    gnome.gnome-calculator
    gnome.simple-scan
    rofi
    gh
    copyq
    libsForQt5.kdeconnect-kde
  ] ++ [
    # browsers/mail
    firefox
    librewolf
    tor-browser
    thunderbird
    electron-mail
    tutanota-desktop
  ] ++ [
    # office
    libreoffice
    pdfarranger
    xournalpp
    rnote
    gimp
  ] ++ [
    # chat/social
    webcord
    element-desktop
  ] ++ [
    # developing
    ansible
    vscode-with-extensions
  ] ++ [
    # games
    lunar-client
    technic-launcher
    superTuxKart
    cemu
    heroic
  ]);

  # gnupg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # thunar
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  # gnome stuff/needed for vscode?
  programs.dconf.enable = true;

  # keyring/kwallet
  environment.sessionVariables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  };

  # syncthing
  services.syncthing = {
    enable = true;
    user = "andiru";
    dataDir = "/home/andiru/Sync";
    configDir = "/home/andiru/.config/syncthing";
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = true; # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "raspberry" = { id = "EZGDIDX-TR7CT44-6OAIXE7-UAOBYVM-Z6RV635-WS7ABKS-NVSFKJG-EPGMCQH"; };
        "lenovo" = { id = "GXH5HAY-VIPVFA2-EMVHC2M-H55OSJ4-BIRSPGI-RIIKOOH-WKBBDQT-2ETLGQV"; };
        "pixel" = { id = "PYTMHAC-ZFGCLBP-GTBID7G-5V5XXL6-S6OEISW-IOFN5BH-3NMSSQ3-PTW22QP"; };
      };
      folders = {
        "default" = {
          path = "/home/andiru/Sync";
          devices = [ "raspberry" "lenovo" "pixel" ];
        };
        "master" = {
          path = "/home/andiru/master";
          devices = [ "raspberry" "lenovo" ];
        };
      };
    };
  };
}

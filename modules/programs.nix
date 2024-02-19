{ pkgs, lib, config, ... }:

let
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config.allowUnfree = true; };
  electron-mail-fix = import (fetchTarball https://github.com/Princemachiavelli/nixpkgs/archive/master.tar.gz) { config.allowUnfree = true; };
  tuta-fix = import (fetchTarball https://github.com/WolfangAukang/nixpkgs/archive/tutanota.tar.gz) { config.allowUnfree = true; };
  technic-launcher = pkgs.callPackage ../derivations/technic-launcher.nix { };
in
{
  # unfree predicate
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode"
      "lunar-client-3.1.0"
      "steam"
      "steam-original"
      "steam-run"
    ];
  };

  # overlays
  nixpkgs.overlays = [
    (final: prev: {
      vscode = unstable.vscode.fhs;
      electron-mail = electron-mail-fix.electron-mail;
      tutanota-desktop = tuta-fix.tutanota-desktop;
    })
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
    gimp
  ] ++ [
    # chat/social
    webcord
    element-desktop
  ] ++ [
    # developing
    vscode
    jdk21
    maven
    ansible
  ] ++ [
    # games
    lunar-client
    technic-launcher
    superTuxKart
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
      };
      folders = {
        "default" = {
          path = "/home/andiru/Sync";
          devices = [ "raspberry" "lenovo" ];
        };
      };
    };
  };
}

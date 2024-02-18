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
  ];

  # andiru packages
  users.users.andiru.packages = with pkgs; [
    firefox
    librewolf
    tor-browser
    thunderbird
    vscode
    webcord
    element-desktop
    vlc
    mpv
    ffmpeg
    gnome.gnome-disk-utility
    gnome.gnome-calculator
    gnome.simple-scan
    libreoffice
    rofi
    neofetch
    yt-dlp
    gh
    lunar-client
    copyq
    flameshot
    technic-launcher
    jdk21
    maven
    electron-mail
    tutanota-desktop
    ansible
    gimp
    pdfarranger
    xournalpp
    superTuxKart
  ];

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
}

{ pkgs, lib, config, ... }:

let
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config.allowUnfree = true; };
  electron-mail-fix = import (fetchTarball https://github.com/Princemachiavelli/nixpkgs/archive/master.tar.gz) { config.allowUnfree = true; };
  technic-launcher = pkgs.callPackage ../derivations/technic-launcher.nix { };
in
{
  # unfree predicate
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode"
      "lunar-client-3.1.0"
    ];
  };

  # overlays
  nixpkgs.overlays = [
    (final: prev: {
      vscode = unstable.vscode.fhs;
      electron-mail = electron-mail-fix.electron-mail;
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    technic-launcher # fixme: cannot start anything :(
    electron-mail
    ansible
    gimp
    pdfarranger
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

  # for like gnome stuff?
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
}

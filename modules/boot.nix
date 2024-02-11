{ lib, ... }:

{
  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ntfs support
  boot.supportedFilesystems = [
    "ntfs"
  ];

  # unlock drives
  boot.initrd.luks.devices."data".device = "/dev/disk/by-uuid/9746be17-e7b2-41bf-b0e9-7c4a0bcb7551";
  boot.initrd.luks.devices."backups".device = "/dev/disk/by-uuid/dd35122a-7071-4748-aebd-bbc293d22267";

  # mount drives
  fileSystems = {
    "/home/andiru/data" = lib.mkForce {
      device = "/dev/mapper/data";
      fsType = "auto";
      options = [
        "nosuid"
        "nodev"
        "x-gvfs-show"
        "noatime"
      ];
    };
    "/run/media/andiru/backups" = {
      device = "/dev/mapper/backups";
      fsType = "auto";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
        "noatime"
      ];
    };
    "/run/media/andiru/steam-games" = {
      device = "/dev/disk/by-uuid/e76dcc56-1f09-42e1-bf87-76008d7066ab";
      fsType = "auto";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
        "noatime"
      ];
    };
    "/run/media/andiru/non-steam-games" = {
      device = "/dev/disk/by-uuid/615db617-10f8-4da3-9ed4-74fc81a3c59c";
      fsType = "auto";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
        "noatime"
      ];
    };
  };
}

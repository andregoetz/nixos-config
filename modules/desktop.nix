{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "/var/lib/AccountsService/icons/andiru-background.png";
    greeters.gtk = {
      enable = true;
      theme = {
        name = "Breeze Dark";
        package = pkgs.libsForQt5.breeze-gtk;
      };
      cursorTheme = {
        name = "Sweet-cursors";
        size = 16;
        package = pkgs.sweet-nova;
      };
      clock-format = "%T";
    };
  };
}

{
  # Enable networking
  networking.networkmanager.enable = true;

  # hostname
  networking.hostName = "andiru-main";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # firewall
  networking.firewall = {
    # kde connect
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedTCPPorts = [
      # syncthing
      8384
      22000
      # mc
      25565
    ];
    allowedUDPPorts = [
      # wireguard
      51820
      # syncthing
      22000
      21027
      # mc
      25565
      # ausweisapp/eid
      24727
    ];
  };

  # julius server wireguard
  networking.wireguard.interfaces = {
    julius-server = {
      ips = [ "10.0.0.3/32" ];
      listenPort = 51820;
      privateKeyFile = "/home/andiru/.nixos-config/files/julius-wg-priv-key";
      peers = [
        {
          publicKey = "8n2woqq0aJR5tSk9/4irt3uaXWYQWrBVq9BCvVTCFTI=";
          allowedIPs = [ "10.0.0.0/24" ];
          endpoint = "wireguard.toastlawine.eu:33333";
          persistentKeepalive = 30;
        }
      ];
    };
  };
}

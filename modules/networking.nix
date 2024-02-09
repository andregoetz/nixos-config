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

  # julius server wireguard
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.interfaces = {
    julius-server = {
      ips = [ "10.0.0.3/32" ];
      listenPort = 51820;
      privateKeyFile = "/etc/nixos/files/julius-wg-priv-key";
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

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andiru = {
    isNormalUser = true;
    useDefaultShell = true;
    description = "Andiru";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6g/r3jUO1Iot99durBRahQiZZjAqpYNpI8A0xjhk5t andiru"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZDNr97sbCgX3Y9nsO+H/M9bRoLPksrqRIhMxMYwjfx andiru"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2/0v7qFTEHugrZ3HY0D6iRpnuASZHHEU2KValzV6Fy andiru"
    ];
  };
}

{ config, lib, ... }:
{
  networking.networkmanager = {
    enable = true;
    # Keep /etc/resolv.conf under NixOS control instead of accepting DHCP DNS.
    dns = "none";
  };

  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = lib.concatMapStrings (server: ''
    nameserver ${server}
  '') config.networking.nameservers;
}

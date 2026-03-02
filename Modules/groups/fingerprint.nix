{ pkgs, ... }:
{
  services.fprintd.enable = true;

  security.pam.services.polkit-1.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
}

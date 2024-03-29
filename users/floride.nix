{ pkgs, ... }:

# Don't forget to set a password with ‘passwd’.
{
  description = "FloRide";
  isNormalUser = true;
  createHome = true;
  extraGroups =
    [ "wheel" "networkmanager" "libvirtd" "docker" "dialout" "scanner" "lp" ];
  shell = pkgs.fish;
}

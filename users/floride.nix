{ pkgs, ... }:

# Don't forget to set a password with ‘passwd’.
{
  description = "Florian Reimat";
  isNormalUser = true;
  createHome = true;
  extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
  shell = pkgs.zsh;
}

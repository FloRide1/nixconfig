# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  services.getty.autologinUser = "floride";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-05d54e16-6a51-4228-a93e-fdbd0638cc19".device =
    "/dev/disk/by-uuid/05d54e16-6a51-4228-a93e-fdbd0638cc19";
  boot.initrd.luks.devices."luks-3bfb2e3f-b04b-43e1-98af-6ac74458398b".device =
    "/dev/disk/by-uuid/3bfb2e3f-b04b-43e1-98af-6ac74458398b";
  boot.initrd.luks.devices."luks-3bfb2e3f-b04b-43e1-98af-6ac74458398b".keyFile =
    "/crypto_keyfile.bin";

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  networking.hostName = "zenk"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/68AA-492A";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/671aa066-2283-4fd4-9dde-71ff6863b379";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/ca02834e-d4ee-44ef-8a66-50a48ec25ad4"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
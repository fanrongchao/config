# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  
  #enable flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    pkgs.distrobox
    vcluster
  ];
  # enable for cursor remote server, patch nodejs
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
  programs.zsh.enable = true;
  users.users.nixos = {
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;
  #enable container and use podman
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;


  # distobox k8s config
  boot.kernelModules = [ "overlay" "br_netfilter" ];
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "net.ipv4.ip_forward" = 1;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

{ config, pkgs, lib, ... }:

{
  # --- User Information ---
  # These are read from the environment at runtime using the --impure flag.
  # This keeps the repository anonymous and shareable.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # --- Home Manager Release ---
  # This value determines the Home Manager release that your configuration is
  # compatible with. Do not change this value even if you update Home Manager.
  home.stateVersion = "25.11";

  # --- Nix Settings ---
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # --- Global Packages ---
  # Packages available in all profiles (Core and GUI)
  home.packages = with pkgs; [
    git
    curl
    fzf
    ripgrep
    fd
    bat
    btop
    glow
    delta
    kanata
    lnav
    zoxide
    unzip
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    statix
    stdenv.cc
    rustup
    libiconv
    uv
  ] ++ (lib.optionals pkgs.stdenv.isLinux [
    # Clipboard utility for Linux systems
    xclip
  ]);

  # --- Environment Variables ---
  home.sessionVariables = {
    RUSTFLAGS = "-L ${pkgs.libiconv}/lib";
  };

  # --- Programs ---
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

{ config, pkgs, ... }:

let
  nvimConfigPath = "${config.home.homeDirectory}/.config/home-manager/dotfiles/nvim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true;
    withRuby = false;
    withPython3 = true;
    extraPython3Packages = ps: with ps; [
      pynvim
      pip
      setuptools
    ];
    extraPackages = with pkgs; [
      gcc
      gnumake
      unzip
      ripgrep
      fd
      nodejs
    ];
  };

  home.packages = [ pkgs.python3 ];

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimConfigPath;
}

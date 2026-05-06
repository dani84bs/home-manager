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
    extraPackages = with pkgs; [
      gcc gnumake unzip ripgrep fd
    ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimConfigPath;
}

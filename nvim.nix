{ config, pkgs, ... }:

let
  # Path to the Neovim configuration directory within your home-manager dotfiles.
  # This path is used to create a symlink so that Neovim can find your Lua configs.
  nvimConfigPath = "${config.home.homeDirectory}/.config/home-manager/dotfiles/nvim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true;

    # Optimization: disable Ruby provider as it's often unused
    withRuby = false;
    withPython3 = true;

    # Python packages required for certain Neovim plugins or providers
    extraPython3Packages = ps: with ps; [
      pynvim
      pip
      setuptools
    ];

    # System packages required by Neovim for Treesitter parsers, 
    # LSP servers, and fuzzy finding.
    extraPackages = with pkgs; [
      gcc
      gnumake
      unzip
      ripgrep
      fd
      nodejs
    ];
  };

  # Ensure a base Python 3 installation is available in the user profile
  home.packages = [ pkgs.python3 ];

  # Symlink the nvim configuration folder to ~/.config/nvim.
  # Using mkOutOfStoreSymlink allows you to edit your Neovim config files 
  # and see changes immediately without needing to run 'home-manager switch'.
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimConfigPath;
}

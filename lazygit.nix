{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;

    # --- UI and Editor Settings ---
    settings = {
      # Use Nerd Fonts version 3 for icons
      ui.nerdFontsVersion = 3;

      # Use Neovim as the default editor preset
      os.editPreset = "nvim";

      # --- Git Pager Configuration ---
      # Configure 'delta' for a more readable and colored diff experience
      git.pagers = [
        { colorArg = "always"; }
        { pager = "delta --dark --paging=never"; }
      ];
    };
  };
}

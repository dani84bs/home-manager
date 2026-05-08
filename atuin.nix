{ pkgs, ... }:

{
  programs.atuin = {
    enable = true;

    # Disable default integrations as they are handled manually in fish.nix
    enableFishIntegration = false;
    enableZshIntegration = false;

    # --- General Settings ---
    settings = {
      filter_mode = "global";
      filter_mode_shell_up_key_binding = "session";
      invert = false;
      enter_accept = true;

      # UI Performance and Motion
      prefers_reduced_motion = true;
      NO_MOTION = true;

      # Sync settings
      sync = {
        records = true;
      };

      # Custom theme selection
      theme = {
        name = "catppuccin-mocha-green";
      };
    };
  };

  # --- Custom Theme Definition ---
  # Create the theme file in the expected Atuin configuration directory.
  # This uses the catppuccin-mocha palette with green highlights.
  xdg.configFile."atuin/themes/catppuccin-mocha-green.toml".text = ''
    [theme]
    name = "catppuccin-mocha-green"
    parent = "marine"

    [colors]
    AlertInfo = "#a6e3a1"
    AlertWarn = "#fab387"
    AlertError = "#f38ba8"
    Annotation = "#a6e3a1"
    Base = "#cdd6f4"
    Guidance = "#9399b2"
    Important = "#f38ba8"
    Title = "#a6e3a1"
  '';
}

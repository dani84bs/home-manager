{ pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = false;
    
    settings = {
      filter_mode = "global";
      filter_mode_shell_up_key_binding = "session";
      invert = false;
      enter_accept = true;
      prefers_reduced_motion = true;
      NO_MOTION = true;
      sync = {
        records = true;
      };
      theme = {
        name = "catppuccin-mocha-green";
      };
    };
  };

  # Create the theme file in the expected directory
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

{ config, pkgs, ... }:

let
  # Kitty wrapper to ensure hardware acceleration works correctly on non-NixOS Linux.
  # It checks for nixGL (Intel, Nvidia, or generic) before launching Kitty.
  # It forces LIBGL_ALWAYS_SOFTWARE to prevent an issue with parallels drivers.
  kitty-wrapper = pkgs.writeShellScriptBin "kitty" ''
    if command -v nixGLIntel >/dev/null 2>&1; then
        LIBGL_ALWAYS_SOFTWARE=1 exec nixGLIntel ${pkgs.kitty}/bin/kitty "$@"
    elif command -v nixGLNvidia >/dev/null 2>&1; then
        LIBGL_ALWAYS_SOFTWARE=1 exec nixGLNvidia ${pkgs.kitty}/bin/kitty "$@"
    elif command -v nixGL >/dev/null 2>&1; then
        LIBGL_ALWAYS_SOFTWARE=1 exec nixGL ${pkgs.kitty}/bin/kitty "$@"
    else
        LIBGL_ALWAYS_SOFTWARE=1 exec ${pkgs.kitty}/bin/kitty "$@"
    fi
  '';
in
{
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  programs.kitty = {
    enable = true;

    # Use the wrapped version of Kitty to handle GPU drivers on Linux
    package = pkgs.symlinkJoin {
      name = "kitty-wrapped";
      paths = [ kitty-wrapper pkgs.kitty ];
    };
    themeFile = "GitHub_Dark";
    # autoThemeFiles.dark = "Gruvbox Dark Hard";
    # autoThemeFiles.light = "GruvboxMaterialLightHard";
    # autoThemeFiles.noPreference = "GruvboxMaterialDarkHard";
    # --- Font Configuration ---
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 16;
    };

    settings = {
      # Use Fish as the default shell within Kitty
      shell = "${pkgs.fish}/bin/fish --login";

      # --- Visuals and Ligatures ---
      disable_ligatures = "always";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # --- Theme: Ir Black ---
      # foreground = "#fdfbee";
      # background = "#000000";
      # selection_foreground = "#fdfbee";
      # selection_background = "#484848";

      # 16 Color Palette
      # color0 = "#000000";
      # color8 = "#484848";
      # color1 = "#ff6c60";
      # color9 = "#ff6c60";
      # color2 = "#a8ff60";
      # color10 = "#a8ff60";
      # color3 = "#ffffb6";
      # color11 = "#ffffb6";
      # color4 = "#96cbfe";
      # color12 = "#96cbfe";
      # color5 = "#ff73fd";
      # color13 = "#ff73fd";
      # color6 = "#c6c5fe";
      # color14 = "#c6c5fe";
      # color7 = "#eeeeee";
      # color15 = "#ffffff";

      # --- Window Appearance ---
      background_opacity = "1.0";
      window_padding_width = 0;
      hide_window_decorations = "no";

      # --- macOS Specific Tweaks ---
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_show_window_title_in = "none";

      # --- Mouse and Clipboard Behavior ---
      copy_on_select = "yes";
      focus_follows_mouse = "yes";
      shell_integration = "no-rc";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
    };
    extraConfig = ''
      include kitty_override.conf
    '';
  };
}

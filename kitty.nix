{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    # Il font viene gestito qui per comodità
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 16;
    };

    settings = {
      shell = "${pkgs.fish}/bin/fish --login";
      # --- Font & Ligatures ---
      disable_ligatures = "always";
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";

      # --- Theme (Ir Black) ---
      foreground           = "#fdfbee";
      background           = "#000000";
      selection_foreground = "#fdfbee";
      selection_background = "#484848";

      # 16 Color Palette
      color0  = "#000000";
      color8  = "#484848";
      color1  = "#ff6c60";
      color9  = "#ff6c60";
      color2  = "#a8ff60";
      color10 = "#a8ff60";
      color3  = "#ffffb6";
      color11 = "#ffffb6";
      color4  = "#96cbfe";
      color12 = "#96cbfe";
      color5  = "#ff73fd";
      color13 = "#ff73fd";
      color6  = "#c6c5fe";
      color14 = "#c6c5fe";
      color7  = "#eeeeee";
      color15 = "#ffffff";

      # --- Appearance ---
      background_opacity      = "1.0";
      window_padding_width    = 0;
      hide_window_decorations = "no";

      # --- macOS Specifics ---
      macos_titlebar_color               = "background";
      macos_option_as_alt                = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_show_window_title_in         = "none";

      # --- Mouse & Clipboard ---
      copy_on_select      = "yes";
      focus_follows_mouse = "yes";
      shell_integration   = "no-rc";
      clipboard_control   = "write-clipboard write-primary read-clipboard read-primary";
    };
  };
}

{ pkgs, lib, ... }:

let
  # Fallback builder for plugins missing from the current Nix channel.
  # Includes a chmod fix to prevent exit code 127 during plugin execution.
  buildTmuxPlugin = name: owner: repo: rev: hash: pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = name;
    version = "unstable-latest";
    src = pkgs.fetchFromGitHub {
      inherit owner repo rev hash;
    };
    postInstall = ''
      find $target -type f \( -name "*.tmux" -o -name "*.sh" \) -exec chmod +x {} \;
    '';
  };

  # --- Manual Fallback Plugins ---
  # Define plugins here if they are not available in the standard nixpkgs tmuxPlugins.
  tmuxCowboy = buildTmuxPlugin "cowboy" "tmux-plugins" "tmux-cowboy" "master" "sha256-KJNsdDLqT2Uzc25U4GLSB2O1SA/PThmDj9Aej5XjmJs=";
  tmuxPainControl = buildTmuxPlugin "pain-control" "tmux-plugins" "tmux-pain-control" "master" "sha256-2VI9w7Naj9OHF3iuV63Ij4QcYhbrtngyJ3GpeyzIKxs=";

in
{
  programs.tmux = {
    enable = true;

    # --- Base Options ---
    keyMode = "vi";
    historyLimit = 100000;
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      # 1. Community Plugins (Maintained by Nix)
      open
      fzf-tmux-url

      # 2. Manual Plugins (Custom derivations defined above)
      tmuxCowboy
      tmuxPainControl

      # 3. Plugins with Extra Configuration
      {
        plugin = session-wizard;
        extraConfig = ''
          set -g @session-wizard 'T'
        '';
      }
      {
        plugin = minimal-tmux-status;
        extraConfig = ''
          set -g @minimal-tmux-justify "left"
          set -g @minimal-tmux-indicator false
          set -g @minimal-tmux-status-left-extra "#S> "
          set -g @minimal-tmux-right false
        '';
      }
    ];

    # --- Raw Configuration (Append to tmux.conf) ---
    extraConfig = ''
      set -g default-shell $SHELL

      # --- Prefix Configuration ---
      # Unbind default Ctrl-b and use semicolon (;) as prefix
      unbind-key C-b
      set -g prefix ";"
      bind-key ";" send-prefix

      # --- General Settings ---
      set -g visual-silence off
      set -g status-interval 1
      set -g display-time 1500
      set -g display-panes-time 10000
      set -g renumber-windows on

      # Enable terminal hyperlink features
      set -sa terminal-features ",*:hyperlinks" 

      # --- OS-Specific Clipboard Integration ---
      # Automatically detects if running on macOS or Linux
      ${if pkgs.stdenv.isDarwin then ''
        set -s copy-command 'pbcopy'
      '' else ''
        set -s copy-command '${pkgs.xclip}/bin/xclip -i -sel clipboard'
      ''}

      # --- Session Management & Keybinds ---
      # Quick configuration reload
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      # Avoid passing control to another session when current one is destroyed
      set -g detach-on-destroy on

      # Hooks to ensure the 'default' session always stays alive
      set-hook -g session-created 'if-shell -F "#{==:#{session_name},default}" { new-window -d -t default }'
      set-hook -g window-unlinked 'if-shell -F "#{==:#{session_name},default}" { if-shell -F "#{==:#{session_windows},1}" { new-window } }'
    '';
  };
}

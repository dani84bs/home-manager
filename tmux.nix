{ pkgs, lib, ... }:

let
  # Fallback builder for plugins missing from the current Nix channel.
  # Includes the chmod fix to prevent exit code 127.
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

  # -----------------------------------------------------------------------------
  # Manual Fallback Plugins
  # Define here ONLY the plugins that throw "undefined variable" errors.
  # Replace lib.fakeHash with the actual hash Nix provides on the first failed run.
  # -----------------------------------------------------------------------------
  tmuxCowboy      = buildTmuxPlugin "cowboy" "tmux-plugins" "tmux-cowboy" "master" "sha256-KJNsdDLqT2Uzc25U4GLSB2O1SA/PThmDj9Aej5XjmJs=";
  tmuxPainControl = buildTmuxPlugin "pain-control" "tmux-plugins" "tmux-pain-control" "master" "sha256-2VI9w7Naj9OHF3iuV63Ij4QcYhbrtngyJ3GpeyzIKxs=";
  
  # Example: If session-wizard or minimal-status fail, uncomment and build them here
  # tmuxSessionWizard = buildTmuxPlugin "session-wizard" "27medkamal" "tmux-session-wizard" "master" lib.fakeHash;
  # minimalTmuxStatus = buildTmuxPlugin "minimal-status" "niksingh710" "minimal-tmux-status" "master" lib.fakeHash;

in
{
  programs.tmux = {
    enable = true;
    
    # Base options
    keyMode = "vi";
    historyLimit = 100000;
    mouse = true;
    
    plugins = with pkgs.tmuxPlugins; [
      # -------------------------------------------------------------------------
      # 1. Community Plugins
      # These are maintained by Nix. No hashes or updates required.
      # Move plugins here if they become available in your channel.
      # -------------------------------------------------------------------------
      open
      fzf-tmux-url

      # -------------------------------------------------------------------------
      # 2. Manual Plugins
      # Injected from the custom derivations defined in the 'let' block above.
      # -------------------------------------------------------------------------
      tmuxCowboy
      tmuxPainControl

      # -------------------------------------------------------------------------
      # 3. Plugins with Extra Configuration
      # Mix and match community or manual plugins here as needed.
      # -------------------------------------------------------------------------
      {
        plugin = session-wizard; # Change to tmuxSessionWizard if community version fails
        extraConfig = ''
          set -g @session-wizard 'T'
        '';
      }
      {
        plugin = minimal-tmux-status; # Change to minimalTmuxStatus if community version fails
        extraConfig = ''
          set -g @minimal-tmux-justify "left"
          set -g @minimal-tmux-indicator false
          set -g @minimal-tmux-status-left-extra "#S> "
          set -g @minimal-tmux-right false
        '';
      }
    ];

    # Raw configuration appended to the end of tmux.conf
    extraConfig = ''
      # -----------------------------------------------------------------------------
      # Prefix Configuration
      # -----------------------------------------------------------------------------
      unbind-key C-b
      set -g prefix ";"
      bind-key ";" send-prefix

      # -----------------------------------------------------------------------------
      # General Settings
      # -----------------------------------------------------------------------------
      set -g visual-silence off
      set -g status-interval 1
      set -g display-time 1500
      set -g display-panes-time 10000
      set -g renumber-windows on

      # Enable hyperlink features
      set -sa terminal-features ",*:hyperlinks" 

      # -----------------------------------------------------------------------------
      # OS-Specific Clipboard Integration
      # -----------------------------------------------------------------------------
      ${if pkgs.stdenv.isDarwin then ''
        set -s copy-command 'pbcopy'
      '' else ''
        set -s copy-command '${pkgs.xclip}/bin/xclip -i -sel clipboard'
      ''}

      # -----------------------------------------------------------------------------
      # Session Management & Keybinds
      # -----------------------------------------------------------------------------
      # Reload configuration shortcut
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      # Avoid passing to another session on destroy
      set -g detach-on-destroy on

      # Always keep the default session alive
      set-hook -g session-created 'if-shell -F "#{==:#{session_name},default}" { new-window -d -t default }'
      set-hook -g window-unlinked 'if-shell -F "#{==:#{session_name},default}" { if-shell -F "#{==:#{session_windows},1}" { new-window } }'
    '';
  };
}

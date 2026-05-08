{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # --- Interactive Shell Initialization ---
    interactiveShellInit = ''
      # Prepend important paths to the environment
      fish_add_path --global --prepend --move \
      "$HOME/.nix-profile/bin" \
      "/nix/var/nix/profiles/default/bin" \
      "$HOME/.local/bin" \
      "/run/current-system/sw/bin" \
      "/usr/local/bin"

      # Set global shell variable and disable greeting
      set -gx SHELL (which fish)
      set fish_greeting

      # Homebrew detection and initialization (Cross-platform)
      if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
      else if test -x /usr/local/bin/brew
        eval (/usr/local/bin/brew shellenv)
      end

      # Cleanup old tide variables to prevent conflicts
      if status is-interactive
          for var in (set -U | string match -r '^tide_')
              set -e $var
          end
      end

      # Initialize CLI tools
      zoxide init fish | source
      atuin init --disable-up-arrow fish | source
    '';

    # --- Shell Aliases ---
    shellAliases = {
      ls = "lsd";
      vim = "nvim";
      glow = "glow -p";
      tmux = "tmux new -A -s default";
      cat = "bat";
      hms = "home-manager switch --flake ~/.config/home-manager#core --impure";
      hms-gui = "home-manager switch --flake ~/.config/home-manager#gui --impure";
    };

    # --- Fish Plugins ---
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "ilancosman";
          repo = "tide";
          rev = "v6.1.1";
          sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }
      {
        name = "pytest-fish";
        src = pkgs.fetchFromGitHub {
          owner = "ddoroshev";
          repo = "pytest.fish";
          rev = "master";
          sha256 = "sha256-Gd3TAFUcYHGS6duNYceo2wWr32X4MWVRpFTanIoYn30=";
        };
      }
    ];
  };

  # --- Configuration Files Managed by Home Manager ---
  home.file = {
    ".config/fish/conf.d/tide_theme.fish".text = ''
      # === TIDE PROMPT CONFIGURATION ===

      # General setup
      set -g tide_prompt_add_newline_before false
      set -g tide_prompt_color_frame_and_connection 808080
      set -g tide_prompt_color_separator_same_color 949494
      set -g tide_prompt_icon_connection \u2500
      set -g tide_prompt_min_cols 34
      set -g tide_prompt_pad_items true
      set -g tide_prompt_transient_enabled false

      # Left Prompt Items
      set -g tide_left_prompt_frame_enabled true
      set -g tide_left_prompt_items pwd git newline character
      set -g tide_left_prompt_prefix \ue0b6
      set -g tide_left_prompt_separator_diff_color \ue0b0
      set -g tide_left_prompt_separator_same_color \ue0b1
      set -g tide_left_prompt_suffix \ue0b0

      # Right Prompt Items
      set -g tide_right_prompt_frame_enabled false
      set -g tide_right_prompt_items status cmd_duration context jobs direnv node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
      set -g tide_right_prompt_prefix \ue0b2
      set -g tide_right_prompt_separator_diff_color \ue0b2
      set -g tide_right_prompt_separator_same_color \ue0b3
      set -g tide_right_prompt_suffix \ue0b4

      # Colors and Icons for Core Components (PWD, Git, Status)
      set -g tide_pwd_bg_color 3465A4
      set -g tide_pwd_color_anchors E4E4E4
      set -g tide_pwd_color_dirs E4E4E4
      set -g tide_pwd_color_truncated_dirs BCBCBC
      set -g tide_pwd_icon \uf07c
      set -g tide_pwd_icon_home \uf015
      set -g tide_pwd_icon_unwritable \uf023
      set -g tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json build.zig

      set -g tide_git_bg_color 4E9A06
      set -g tide_git_bg_color_unstable C4A000
      set -g tide_git_bg_color_urgent CC0000
      set -g tide_git_color_branch 000000
      set -g tide_git_icon \uf1d3
      set -g tide_git_truncation_length 24

      set -g tide_status_bg_color 2E3436
      set -g tide_status_bg_color_failure CC0000
      set -g tide_status_color 4E9A06
      set -g tide_status_color_failure FFFF00
      set -g tide_status_icon \u2714
      set -g tide_status_icon_failure \u2718

      # Tooling and Language specific settings
      set -g tide_rustc_bg_color F74C00
      set -g tide_rustc_icon \ue7a8
      set -g tide_python_bg_color 444444
      set -g tide_python_color 00AFAF
      set -g tide_python_icon \U000f0320
      set -g tide_nix_shell_bg_color 7EBAE4
      set -g tide_nix_shell_icon \uf313
      
      # VI Mode and Character settings
      set -g tide_character_color 5FD700
      set -g tide_character_color_failure FF0000
      set -g tide_character_icon \u276f
      set -g tide_vi_mode_bg_color_default 949494
      set -g tide_vi_mode_bg_color_insert 87AFAF
      set -g tide_vi_mode_bg_color_visual FF8700

      # Command Duration settings
      set -g tide_cmd_duration_bg_color C4A000
      set -g tide_cmd_duration_color 000000
      set -g tide_cmd_duration_threshold 3000
      set -g tide_cmd_duration_icon \uf252
    '';

    ".config/fish/conf.d/syntax_theme.fish".text = ''
      # === SYNTAX HIGHLIGHTING COLORS ===
      set -g fish_color_autosuggestion 707A8C
      set -g fish_color_command 5CCFE6
      set -g fish_color_comment 5C6773
      set -g fish_color_cwd 73D0FF
      set -g fish_color_end F29E74
      set -g fish_color_error FF3333
      set -g fish_color_quote BAE67E
      set -g fish_color_param CBCCC6
    '';
  };
}

# Dani's Dotfiles (Nix Flake Edition)

A modular, layered configuration for **Home Manager** using **Nix Flakes**.
This setup is designed to be cross-platform (Linux/macOS) and anonymous,
utilizing the `--impure` flag to adapt to different users and environments
without hardcoding personal data.

## 🏗 Architecture

The configuration is split into two main layers defined in `flake.nix`:

- **core**: Terminal-only environment (Fish, Tmux, Neovim, LSD, Atuin, etc.).
  Ideal for SSH sessions or servers.
- **gui**: Full desktop environment. Includes everything in core plus graphical
  tools like Kitty.

## 🚀 Getting Started

### 0. Install Nix

If you haven't installed Nix yet, the recommended way is using the Determinate
Systems installer:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Alternatively, use the official multi-user installation:

```bash
sh <(curl -L <https://nixos.org/nix/install>) --daemon
```

**Enable Flakes:**
If you choose the official multi-uer installaton ensure that Nix Flakes are
enabled by adding the following to your `/etc/nix/nix.conf` (or
`~/.config/nix/nix.conf`):

```
experimental-features = nix-command flakes
```

### 1. Prerequisites

Ensure Nix is installed and Flakes are enabled. If you are on a non-NixOS Linux
distribution and need hardware acceleration for GUI apps, install nixGL
manually:

```bash
nix profile add --impure github:nix-community/nixGL
```

### 2. Installation

Clone this repository directly into your Home Manager configuration directory:

```bash
mkdir -p ~/.config/home-manager
git clone https://github.com/dani84bs/home-manager.git ~/.config/home-manager
cd ~/.config/home-manager
```

### 3. Applying Configuration

Choose the layer that fits your current machine.

**Note:** The --impure flag is mandatory as it allows Nix to detect your $USER
and $HOME dynamically via builtins.getEnv.

**For a Server / CLI-only environment:**

```bash
nix run -- home-manager switch --flake .#core --impure
```

**For a Desktop environment (Linux or macOS):**

```bash
nix run -- home-manager switch --flake .#gui --impure
```

## 🔄 Daily Workflow

### Synchronizing Changes

The workflow is designed to be simple and "git-centric":

1. **Edit**: Modify any .nix file in ~/.config/home-manager.
2. **Apply**: Run the home-manager switch command.
3. **Sync**: Commit and push your changes.
4. **Update elsewhere**: On another machine, simply git pull and run the switch
   command again.

### Updating Packages

To update all tools to the latest versions in **nixpkgs-unstable**:

```bash
nix flake update
home-manager switch --flake .#gui --impure
```

## ⌨️ Recommended Aliases

Once Fish is configured, you can use these shortcuts:

- `hms`: to rebuild the system.
- hms-gui: to upgrade and rebuild the system.

## 🛠 Troubleshooting

### "Error installing file ... outside $HOME" (macOS)

This happens if there is a path mismatch. Ensure home.homeDirectory in home.nix
matches your echo $HOME output exactly (usually /Users/dani). Also, move any
existing config folders (like ~/.config/nvim) before the first run.

### Kitty crashing on Linux

Ensure nixGL is installed. The configuration includes a wrapper that
automatically looks for nixGLIntel or nixGL in your profile.

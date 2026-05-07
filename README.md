# My home-manager setup

## Fast bootstrap

- Clone this repo.

  ```bash
  git clone https://github.com/dani84bs/home-manager.git .config/home-manager
  ```

- Install nix.

  ```bash
  curl -L https://nixos.org/nix/install | sh -s -- --daemon
  ```

- Restart the shell or source nix to set the paths.
- Install **home-manager** channel & tool.

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

- **OPTIONAL** Install **nixgl**.

```bash
nix --extra-experimental-features "nix-command flakes" profile install --impure github:nix-community/nixGL#nixGLIntel
```

- Apply your configuration.

```bash
home-manager switch
```

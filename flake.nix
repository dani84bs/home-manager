{
  description = "Dani's Universal Home Manager Flake";

  inputs = {
    # Use nixpkgs unstable for the latest tools
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Automatically detect the system architecture (e.g., x86_64-linux, aarch64-darwin)
      # This requires the --impure flag during switch
      system = builtins.currentSystem;
      pkgs = nixpkgs.legacyPackages.${system};

      # Base modules shared by all profiles (CLI tools)
      baseModules = [
        ./home.nix
        ./fish.nix
        ./tmux.nix
        ./lsd.nix
        ./atuin.nix
        ./nvim.nix
        ./lazygit.nix
      ];
    in
    {
      homeConfigurations = {
        # CORE LAYER: Terminal-only environment (perfect for SSH)
        core = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = baseModules;
        };

        # GUI LAYER: Full environment including Kitty and graphical tweaks
        gui = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = baseModules ++ [ ./kitty.nix ];
        };
      };
    };
}

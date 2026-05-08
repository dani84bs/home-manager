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
      # Automatically detect the system architecture
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

      # Helper function to inject the profile name into the modules
      mkConfig = profileName: extraModules: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # This passes the 'profile' variable to fish.nix, home.nix, etc.
        extraSpecialArgs = { profile = profileName; };
        modules = baseModules ++ extraModules;
      };
    in
    {
      homeConfigurations = {
        # CORE LAYER: Terminal-only environment
        core = mkConfig "core" [ ];

        # GUI LAYER: Full environment including Kitty
        gui = mkConfig "gui" [ ./kitty.nix ];
      };
    };
}

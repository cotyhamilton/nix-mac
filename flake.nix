{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.age
            pkgs.doctl
            pkgs.fzf
            pkgs.gh
            pkgs.google-chrome
            pkgs.gnupg
            pkgs.imagemagick
            pkgs.k9s
            pkgs.neovim
            pkgs.sops
            pkgs.sqlite
            pkgs.stow
            pkgs.vscode
          ];

          fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
          ];

          homebrew = {
            enable = true;
            onActivation = {
              # autoUpdate = true;
              # upgrade = true;
              cleanup = "zap";
            };
            casks = [
              "ghostty"
              "orbstack"
              "raycast"
              "whisky"
            ];
            brews = [
              "n"
            ];
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          nix.extraOptions = ''
            extra-platforms = x86_64-darwin aarch64-darwin
          '';

          security.pam.services.sudo_local.touchIdAuth = true;

          system.defaults = {
            dock.autohide = true;
            finder.AppleShowAllExtensions = true;
            finder.AppleShowAllFiles = true;
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#book
      darwinConfigurations."book" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "cotyhamilton";
              autoMigrate = true;
            };
          }
        ];
      };
    };
}

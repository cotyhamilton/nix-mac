# nix mac

Nix config for my mac

## Install nix

```bash
curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  -L https://install.determinate.systems/nix \
  | sh -s -- install
```

## Bootstrap

```bash
nix run nix-darwin -- switch --flake github:cotyhamilton/nix-mac#book
```

## Update

Clone repo

```bash
git clone https://github.com/cotyhamilton/nix-mac.git ~/nix
```

Rebuild

```bash
darwin-rebuild switch --flake ~/nix#book
```

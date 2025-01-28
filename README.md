# nix mac

Nix config for my mac

## install nix

```bash
curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  -L https://install.determinate.systems/nix \
  | sh -s -- install
```

## bootstrap

```bash
nix run nix-darwin -- switch --flake github:cotyhamilton/nix-mac#book
```

## update

Clone repo

```bash
git clone https://github.com/cotyhamilton/nix-mac.git ~/nix
```

Rebuild

```bash
darwin-rebuild switch --flake ~/nix#book
```

## reference

- [youtube (dreams of autonomy)](https://youtu.be/Z8BL8mdzWHI)
- [nix-darwin config options](https://daiderd.com/nix-darwin/manual/)

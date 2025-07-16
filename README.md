# NixOS Config

This is my personal NixOS and Home Manager configuration.

It manages my system, dotfiles, development tools, and editor settings using Nix flakes.  

## Usage

### 1. Clone the Repo

```
git clone git@github.com:rickdaalhuizen90/nixos-config.git  ~/.nixos-config
```

### 2. Generate Hardware Configuration

```
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### 3. Link Your Config

```
sudo ln -s ~/.nixos-config /etc/nixos
```

### 4. Build and Activate

```
sudo nixos-rebuild switch --flake ~/.nixos-config
```

---

See [NixOS manual](https://nixos.org/manual/nixos/stable/index.html) for more information on system configuration and flakes.

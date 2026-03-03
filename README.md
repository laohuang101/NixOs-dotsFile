# Rebuild
``` sudo nixos-rebuild switch --flake .#nixos ```

# CleanUp
``` sudo nix-collect-garbage -d ```

# Update
```
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

# OS
NixOs 26.05

# Package count
1376

# Shell
fish 4.5.0

# WM
niri 25.11 (Wayland)

# Terminal
kitty 0.45.0



if cloning the dot file should fixed the brightness control problem

# Noctalia link
``` ln -sfn $(nix build --no-link --print-out-paths /etc/nixos#noctalia)/share/noctalia-shell ~/.config/quickshell/noctalia-shell ```


# Pinyin input 
fcitx5-configtool


# Migration
## Can try this but not sure if it works or not

```
# 1. Move to the config folder
cd /etc/nixos

# 2. Keep the NEW hardware file (this is the only file unique to this PC)
sudo cp hardware-configuration.nix ~/hardware-backup.nix

# 3. Delete the default configuration
sudo rm *.nix

# 4. Pull your setup from GitHub
# (Note: we use '.' to clone into the current folder)
sudo git clone https://github.com/laohuang101/NixOs-dotsFile.git .

# 5. Put the NEW hardware file back in
sudo cp ~/hardware-backup.nix ./hardware-configuration.nix
```


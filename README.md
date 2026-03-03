# Migrate (This is super duper slow...)
```
sudo nixos-rebuild switch --flake /etc/nixos#nixos --max-jobs 1 --cores 1
```
- If RAM enough can remove the --max-jobs 1 --cores 1

# Rebuild
``` 
cd /etc/nixos
sudo nixos-rebuild switch --flake .#nixos
```

# CleanUp
``` 
sudo nix-collect-garbage -d
```

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
``` 
# 1. Create the parent folder
mkdir -p ~/.config/quickshell

# 2. Create the link
# (Assuming your folder is in your home directory)
ln -s /home/loke/noctalia-shell ~/.config/quickshell/noctalia-shell
```


# Pinyin input 
fcitx5-configtool


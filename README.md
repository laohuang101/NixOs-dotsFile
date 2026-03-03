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

# rEFInd
```
git clone https://github.com/gutlessCGH/RONBM.git ~/Downloads/RONBM

# 1. Create a safe folder outside of the 'refind' directory
sudo mkdir -p /boot/EFI/themes/RONBM

# 2. Copy your downloaded theme into the safe folder
sudo cp -r ~/Downloads/RONBM/* /boot/EFI/themes/RONBM/

# 3. Fix the paths inside the theme to point to the safe folder
sudo sed -i 's|themes/[^/]*/|/EFI/themes/RONBM/|g' /boot/EFI/themes/RONBM/theme.conf
```


- Verify
  ```
  sudo sed -i 's|themes/[^/]*/|/EFI/themes/RONBM/|g' /boot/EFI/themes/RONBM/theme.conf
  ```


# Pinyin input 
fcitx5-configtool

# Monster-Siren
```
git clone https://github.com/khanhn201/monster-siren-download.git
cd monster-siren-download
nix-shell -p ffmpeg "python3.withPackages(ps: with ps; [ requests tqdm pillow mutagen pydub ])" --run fish
```
```
# Create the environment and tell it to inherit the Nix packages
python -m venv .venv --system-site-packages

# Activate the virtual environment in Fish
source .venv/bin/activate.fish

# Install the one missing pure-Python package
pip install pylrc

# Start the downloader!
python main.py
```

# Upcomming
- Word list
- Other CTF tools
- Ascii Img
- Login rice
- Monster-Siren list download



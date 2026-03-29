# Migrate (This included zed and other application that is super duper slow to download...)
```
# Create an 64GB swap file
sudo fallocate -l 64G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Run your rebuild again (if u want u can set the core limit use)
sudo nixos-rebuild switch --cores 5

# Turn off and remove the swap file once you're done
sudo swapoff /swapfile
sudo rm /swapfile
```

# Rebuild
``` 
cd /etc/nixos
sudo nixos-rebuild switch --flake .#nixos
```

# CleanUp
``` 
sudo nix-collect-garbage -d
```

# Build cache clear
```
sudo rm -rf /nix/var/nix/builds/*
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

# Winsapp
## Change xml to spoof hardware(for VM)
```
<os firmware="efi">
  <type arch="x86_64" machine="q35">hvm</type>
  <smbios mode="host"/>
</os>
<sysinfo type="smbios">
  <oemStrings>
    <entry>BypassTPMCheck</entry>
    <entry>BypassSecureBootCheck</entry>
  </oemStrings>
</sysinfo>
```

## Add TPM
add hardware -> tpm

## Pull winapps repo and create configuration create configuration
```
git clone https://github.com/winapps-org/winapps.git ~/.local/share/winapps
cd ~/.local/share/winapps
mkdir -p ~/.config/winapps
nano ~/.config/winapps/winapps.conf
```

```
RDP_USER="winapps"
RDP_PASS="mypassword"
WAFLAVOR="libvirt"
GUEST_NAME="RDPWindows"
LIBVIRT_URI="qemu:///system"
```
## Check windows activation key

```
sudo strings /sys/firmware/acpi/tables/MSDM
```

## In windows
1. Upgrade using pro key

   ```
   VK7JG-NPHTM-C97JM-9MPGT-3V66T
   ```
2. Create winapss user and password
3. Allow the user to have admin access
```
net user winapps mypassword /add
net localgroup administrators winapps /add
```

4. Add the user to the Remote Desktop whitelist
*in remote desktop settings -> add user

```
:: 1. The standard allowlist disable
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList" /v fDisabledAllowList /t REG_DWORD /d 1 /f

:: 2. The Group Policy override
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fAllowUnlistedRemotePrograms /t REG_DWORD /d 1 /f

:: 3. The 'Applications Specified' override
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList" /v fApplicationsSpecified /t REG_DWORD /d 0 /f
```


## Run installation
```
rm -rf ~/.config/freerdp/server
cd ~/.local/share/winapps
LIBVIRT_DEFAULT_URI="qemu:///system" ./setup.sh
```

## VM does not exist error & App not exist error
```
mkdir -p ~/.config/libvirt
echo 'uri_default = "qemu:///system"' >> ~/.config/libvirt/libvirt.conf
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Check which vm is running
```
virsh -c qemu:///system list --all
```

## ERROR: GROUP MEMBERSHIP CHECK ERROR.
```
# Create the group that the script expects
sudo groupadd libvirt
# Add yourself to both the real NixOS group and the dummy group
sudo usermod -a -G libvirt loke
sudo usermod -a -G libvirtd loke
sudo usermod -a -G kvm loke
```

## ERROR: WINDOWS VM DOES NOT EXIST.
```
cd ~/.local/share/winapps
LIBVIRT_DEFAULT_URI="qemu:///system" ./setup.sh
```

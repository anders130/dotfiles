# Dotfiles
## Installation
### Fish
Download the package for your distro from https://fishshell.com/
```bash
sudo dpkg -i fish_<version>_amd64.deb
```
Set fish as the default shell
```bash
chsh -s $(which fish)
```
### Nvim
Install nvim
```bash
sudo apt install snap
snap install --edge nvim --classic
```

Run the installation script
```bash
chmod +x install.sh
./install.sh
```

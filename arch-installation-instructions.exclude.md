# Arch installation instructions

This could have pretty much become a shell script but I decided to include it as a README file because there are many considerations that should be thought and done manually.

The following steps are written in order.

## Update repositories

```shell
# Use iwctl if connecting to internet through wifi
timedatectl set-ntp true
pacman -Syyy
pacman -S reflector
reflector -c us -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyy
```

## Setup disks

```shell
lsblk
# Create GPT partition table
# EFI partition 260M
# Swap partition (half or the same as available RAM) 8G
lsblk
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab

```

## Set region and locale

```shell
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Monterrey /etc/localtime
hwclock --systohc
# Edit /etc/locale.gen and uncomment "en_US.UTF-8 UTF-8"
locale-gen
# Edit /etc/locale.conf and write "LANG=en_US.UTF-8"
# Edit /etc/hostname and write the name of the machine e.g. "mypc"
# Edit /etc/hosts and add:
# 127.0.0.1	localhost
# ::1		localhost
# 127.0.1.1	mypc.localdomain	mypc
```

## Install grub and other essential software (omit as needed if you know what you are doing)

```shell
pacman -S grub efibootmgr dosfstools mtools networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober base-devel linux-headers reflector git bluez bluez-utils cups xdg-utils xdg-user-dirs pulseaudio openssh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
```

## Configure users

```shell
passwd
useradd -mG wheel jonark
passwd jonark
EDITOR=vim visudo
# Edit visudo and uncomment %wheel ALL=(ALL) ALL
exit
umount -a
reboot
```

## Install personal software/drivers (and display manager)

```shell
# Now install video drivers (for intel graphics card, xf86-video-intel)
sudo pacman -S nvidia nvidia-utils nvidia-settings
# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
# Install display manager
sudo pacman -S xorg lightdm
yay -S lightdm-slick-greeter
sudo systemctl enable lightdm
# Modify /etc/lightdm/lightdm.conf and
# set greeter-session=lightdm-slick-greeter
# under section [Seat:*]
# Install WM
sudo pacman -S i3-wm i3status i3lock dmenu rofi polybar xdg-utils scrot xclip picom 
# Terminal tools
yay -S alacritty playerctl pulsemixer feh ranger ueberzug htop
# Fonts
yay -S noto-fonts noto-fonts-emoji noto-fonts-cjk
# Thunar file explorer, plugins, thumbnails, archive managers, remote access
yay -S thunar thunar-archive-plugin file-roller tumbler gvfs gvfs-smb sshfs
yay -S ttf-ms-fonts // And install win10-auto
# SSD trim
sudo systemctl enable fstrim.timer
reboot
# Clone and apply dotfiles
# Install wallpapers in /usr/share/background
# Install my programs
yay -Sy ncspot brave discord_arch_electron vlc
# Gaming mouse support
yay -Sy piper
# Noise suppression
yay -Sy noisetorch-bin
# Install Grub Customizer for dual boot
# Customize Greeter, add this to /etc/lightdm/slick-greeter.conf
[Greeter]
background=/usr/share/backgrounds/greeter.jpg

```

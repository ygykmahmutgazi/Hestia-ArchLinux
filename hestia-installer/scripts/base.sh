#!/bin/bash

loadkeys trq
setfont iso09.16
fdisk -l
cfdisk
echo "initializing disk configuration"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
blkid
swapon /dev/sda3
echo "Setting up database"
pacman -Syy
mount /dev/sda2 /mnt
echo "Starting the basic components installation"
pacstrap /mnt base linux linux-firmware vim nano git ark
echo "Creating Fstab file"
genfstab -U /mnt >> /mnt/etc/fstab
echo "Installing Graphical Drivers"
pacman -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader ntp
echo "Installing base Applications"
pacman -S gimp vlc firefox thunderbird kate krita"
echo "Installing Mate DE"
pacman -S mate network-manager-applet mate-extra dconf-editor lightdm lightdm-slick-greeter lightdm-settings
systemctl enable lightdm.service --force
echo "Switching to root user"
arch-chroot /mnt
echo "Setting timezone to Istanbul"
timedatectl set-timezone Europe/Istanbul
timedatectl set-ntp true
echo "Setting to Turkish Language"
locale-gen
echo LANG=tr_TR.UTF-8 > /etc/locale.conf
export LANG=tr_TR.UTF-8
nano /etc/locale.gen
locale-gen
echo "Adding Hosts"
echo hestia > /etc/hostname
touch /etc/hosts
nano /etc/hosts
echo "Setting Root Password"
passwd
echo "Installing GRUB"
pacman -S grub efibootmgr networkmanager intel-ucode
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
echo "Adding Wheel User"
useradd -m -g users -G optical,storage,wheel,video,audio,users,power,network,log -s /bin/bash hestia
passwd hestia
nano /etc/sudoers
echo "Installing Xorg"
pacman -S xorg xorg-server
systemctl enable NetworkManager.service
echo "Installing AUR helper"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
echo "Rebooting"
reboot

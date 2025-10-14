## Download
Visit [nixos.org](https://nixos.org/download/) and download the minimal ISO image for your architecture. Flash the ISO onto an 8GB or larger USB using [Balena](https://etcher.balena.io/). Boot into this USB on the device you'll be installing to

## SSH
Set a password for root and check the IP address, so you can SSH in
```
$ sudo passwd root
$ ip addr
```

## Disk Setup
Identify the disks you'll be installing to
```
$ lsblk
```

Write random data to the disks to hide the data boundary. Be advised that this will, irrevocably, wipe all data on these disks
```
$ dd if=/dev/urandom of=/dev/nvme0n1 status=progress bs=4096
```

## Partitioning
Use gdisk to create your partitions
```
$ gdisk /dev/nvme0n1
```
Print the partition table with `p`. Create new partitions using `n` and match the following:
| **#** | **First Sector** | **Last Sector** | **Code** |
|:-----:|:----------------:|:---------------:|:--------:|
|   1   |      default     |      +512M      |   ef00   |
|   2   |      default     |       +4G       |   ef02   |
|   3   |      default     |     default     |   8309   |

Apply the changes with `w`. Repeat these steps on the home disk (when applicable)
| **#** | **First Sector** | **Last Sector** | **Code** |
|:-----:|:----------------:|:---------------:|:--------:|
|   1   |      default     |     default     |   8302   |

## Encryption
Load the encryption modules
```
$ modprobe dm-crypt
$ modprobe dm-mod
```

Set up encryption on the 3rd partition of the main disk and the home disk (when applicable)
```
$ cryptsetup luksFormat -v -s 512 -h sha512 /dev/nvme0n1p3
$ cryptsetup luksFormat -v -s 512 -h sha512 /dev/nvme1n1p1
```
Ensure you choose an effective passphrase (6-8 words) and **keep it secure**

Open the disks (including home, when applicable)
```
$ cryptsetup open /dev/nvme0n1p3 luks_lvm
$ cryptsetup open /dev/nvme1n1p1 nixos-home
```

## Volume Setup
Create the volume and volume group
```
$ pvcreate /dev/mapper/luks_lvm
$ vgcreate nixos /dev/mapper/luks_lvm
```

Create a volume for the swap space. This should be the size of your RAM, plus 2GB.
```
$ lvcreate -n swap -L 66G nixos
```

Create the root volume
```
$ lvcreate  -n root -l +100%FREE nixos
```

## Filesystems
FAT32 on the EFI partition
```
$ mkfs.fat -F32 /dev/nvme0n1p1
```
EXT4 on the boot partition
```
$ mkfs.ext4 /dev/nvme0n1p2
```
BTRFS on the root partition
```
$ mkfs.btrfs -L root /dev/mapper/nixos-root
```
When applicable, BTRFS on the home disk
```
$ mkfs.btrfs -L home /dev/mapper/nixos-home
```

Set up the swap device
```
$ mkswap /dev/mapper/nixos-swap
```

## Mounting
Mount the swap device
```
$ swapon /dev/mapper/nixos-swap
$ swapon -a
```
Mount the root directory
```
$ mount /dev/mapper/nixos-root /mnt
```
Create the home and boot directories
```
$ mkdir -p /mnt/{home,boot}
```
Mount the boot partition
```
$ mount /dev/nvme0n1p2 /mnt/boot
```
If there's a home disk, mount the home partition
```
$ mount /dev/mapper/nixos-home /mnt/home
```
Create and mount the EFI directory
```
$ mkdir /mnt/boot/efi
$ mount /dev/nvme0n1p1 /mnt/boot/efi
```

## Bootstrap Configuration
Generate the default configuration files
```
$ nixos-generate-config --root /mnt
```

Note the UUID of the root and (when applicable) home partitions
```
$ lsblk -f
```

Note the ID of the disk that contains the `/boot` partition. For example, in this case, the ID is `nvme-Samsung_SSD_990_PRO_2TB_S73WNU0XB12209B`. If no such line exists, which is sometimes the case for virtual machines, use the kernel device name, such as `/dev/vda`.
```
$ ls -l /dev/disk/by-id/
```

Open `hardware-configuration.nix`
```
$ nano /mnt/etc/nixos/hardware-configuration.nix
$ vim /mnt/etc/nixos/hardware-configuration.nix
```

Add the following lines, ensuring there's no duplication. Uncomment the home partition as needed. Save and exit
```
boot.loader.grub.device = "/dev/disk/by-id/<ROOT DISK ID>";
boot.initrd.luks.devices."luks_lvm".device = "/dev/disk/by-uuid/<ROOT PARTITION UUID>";
# boot.initrd.luks.devices."luks_home".device = "/dev/disk/by-uuid/<HOME PARTITION UUID>";
```

Open the default `configuration.nix` in a text editor
```
$ nano /mnt/etc/nixos/configuration.nix
$ vim /mnt/etc/nixos/configuration.nix
```
Delete the contents of the file. This can be done quickly like so:
```
Nano: Alt + \, Alt + T
Vim: Esc, gg, dG
```
Copy the full contents of [bootstrap.nix](bootstrap.nix) into the configuration.nix file. Save and exit


## Installation
Install NixOS. Be advised that virtual machines must be booted in UEFI mode for this to succeed
```
$ nixos-install --root /mnt
```
Unmount `/mnt`
```
$ umount -R /mnt
```
Finally, reboot and remove the installation media 
```
$ reboot
```
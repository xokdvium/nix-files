#!/usr/bin/env bash

# NixOS install script that I use on my machines. It nukes the partition table
# and creates a ESP and a ZFS pool on the specified device.
# Based on: https://github.com/voidzero/nixos-zfs-setup
#
# Edit the variables below. Then run this by issuing:
# `./os-install.sh`
#
# To view available options run:
# `./os-install.sh -h`

###############################################################################
#    nixos-zfs-setup.sh: a bash script that sets up zfs disks for NixOS.      #
#      Copyright (C) 2022  Mark (voidzero) van Dijk, The Netherlands.         #
#                    2023  Sergei Zimmerman (xokdvium)                        #
#    This program is free software: you can redistribute it and/or modify     #
#    it under the terms of the GNU General Public License as published by     #
#    the Free Software Foundation, either version 3 of the License, or        #
#    (at your option) any later version.                                      #
#                                                                             #
#    This program is distributed in the hope that it will be useful,          #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
#    GNU General Public License for more details.                             #
#                                                                             #
#    You should have received a copy of the GNU General Public License        #
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.   #
###############################################################################

print_banner() {
  cat <<EOF
# Welcome to os-install.sh -- a NixOS installation script with ZFS root
# filesystem. Part of my declarative system configuration and is supposed to be
# used together with the flake: https://github.com/xokdvium/nix-files


              :===-        :******:     .+***-
             .=====-        :******-   .******:
              :======.       .******= :******-
               .======.        +*****+******:
                :======:       .=**********.
        :=======================:-*******+.       ..
       :=========================:-******:       :==:
      .------------------------::-.:******-     :====:
                -+++++=             .******-   -=====-
               =*****+.              .+*****= -=====-
              +*****=                  =***+:======:
 .-----------******-                    =*=:-=====-:::::::.
-*****************:                      ::================:
-****************-.                      :=================.
 .-------******+:-=:                    :=====-...........
        =*****+:-===-                  -=====-
       +*****+ :=====-               .-=====:
     .******=   :======.             :-----.
      =****-     :======.-+++++++++++++++++++++++++++:
       -**:       :======:=*************************-
        ::       .-=======:-***********************:
                .==========-.       -******: .
               :======-=====-        :******:
              :======. :======.       :******-
             .=====-    :======.       .+*****:
              :===-      :======.        +***-


EOF
}

set -exo pipefail

# How to name the partitions. This will be visible in 'gdisk -l /dev/disk' and
# in /dev/disk/by-partlabel.

# Hardcoded non-configurable options
PART_EFI="efi"
PART_SWAP="swap"
PART_ROOT="rpool"

ZFS_ROOT="rpool"
ZFS_ROOT_VOL="nixos"
EMPTYSNAP="sysinit"
IMPERMANENCE=true

HWCFG="/mnt/etc/nixos/hardware-configuration.nix"
ZFSCFG="/mnt/etc/nixos/zfs.nix"

set +x

usage() {
  echo "Usage: $(basename "$0") [-h]"
}

while getopts "h" options; do
  case "${options}" in
    *)
      usage
      exit 1
      ;;
  esac
done

print_banner

read -rp "Choose a drive to install the system on (e.g. /dev/sda): " DISK
read -rp "Please specify Swap size (e.g. 2GiB): " SWAPSIZE

# TODO: Improve this selection
if [ -n "${HOSTNAME}" ]; then
  cat << EOF
Please select the host:
1) nanospark
2) nebulinx
EOF
  read -rp "Enter an index (1-2): " answer
  case ${answer:0:1} in
    1 )
      HOSTNAME="nanospark"
      ;;
    2 )
      HOSTNAME="nebulinx"
      ;;
    * )
      exit 1;
      ;;
  esac
fi

read -rp "Please specify ZFS ARC size (e.g. 2Gi): " ARCSIZE_RAW
ZFS_ARCSIZE=$(echo "${ARCSIZE_RAW}" | numfmt --from=auto)

wipe_filesystem() {
  read -rp "Are you sure you want to wipe ${DISK} (y/n)? " ANS
  case ${ANS:0:1} in
    y|Y )
      ;;
    * )
      exit 1;
      ;;
  esac

  echo "Wiping the filesystem on ${DISK}"
  set -x
  wipefs -a "${DISK}"
  set +x
}

format_disk() {
  # Partition the drive in a simple manner:
  # - 1: Root ZFS filesystem
  # - 2: Swap with configurable size
  # - 3: EFI System Partition
  parted -s "${DISK}" -- mklabel gpt

  parted -s "${DISK}" -- mkpart primary 512MiB -"${SWAPSIZE}"
  parted -s "${DISK}" -- mkpart primary linux-swap -"${SWAPSIZE}" 100%
  parted -s "${DISK}" -- mkpart ESP fat32 1MiB 512MiB

  parted -s "${DISK}" -- name 1 "${PART_ROOT}"
  parted -s "${DISK}" -- name 2 "${PART_SWAP}"
  parted -s "${DISK}" -- name 3 "${PART_EFI}"

  parted -s "${DISK}" -- set 3 esp on

  # TODO: Maybe there's a better way than a hardcoded delay to achive this?
  # Wait for a bit to let udev catch up and generate /dev/disk/by-partlabel.
  sleep 3s

  # Create root pool
  zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O compression=zstd \
    -O dnodesize=auto -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=none \
    -O checksum=edonr \
    -R /mnt \
    -f \
    ${ZFS_ROOT} /dev/disk/by-partlabel/${PART_ROOT}*

  # Create the root dataset
  zfs create -o mountpoint=/ ${ZFS_ROOT}/${ZFS_ROOT_VOL}

  # Create datasets (subvolumes) in the root dataset
  zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/home
  zfs create -o atime=off ${ZFS_ROOT}/${ZFS_ROOT_VOL}/nix
  zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/root
  zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/usr
  zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/var

  if [[ "${IMPERMANENCE}" = true ]]; then
    zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/persistent
    for i in "" /usr /var
    do
      zfs snapshot ${ZFS_ROOT}/${ZFS_ROOT_VOL}${i}@${EMPTYSNAP}
    done
  fi

  mkswap /dev/disk/by-partlabel/${PART_SWAP} -L swap
  mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/${PART_EFI}
}

wipe_filesystem
format_disk

set -x

# Installation
mkdir -p /mnt/boot
mount /dev/disk/by-partlabel/${PART_EFI} /mnt/boot
swapon /dev/disk/by-partlabel/${PART_SWAP}

nixos-generate-config --root /mnt

sed -i "s/imports\s*=\s*\[.*\];/imports = [ \.\/zfs\.nix ];/g" \
  ${HWCFG}

tee -a ${ZFSCFG} <<EOF
{ config, lib, pkgs, ... }:
{
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha512" "${HOSTNAME}");
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "zfs.zfs_arc_max=${ZFS_ARCSIZE}" ];
  boot.zfs.devNodes = "/dev/disk/by-partlabel";
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
}
EOF

cat <<-EOF
  # Now you can do any manual setup that is required. When you are finished, run
  # these commands:

  nixos-install --root /mnt
  umount -Rl /mnt # Necessary to export the pool
  zpool export -a # Not sure why, but this is necessary to make the system bootable
  swapoff -a
  reboot # Hopefully reboot into a working installation of NixOS
EOF

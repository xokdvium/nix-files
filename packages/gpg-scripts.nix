# Yoinked from: https://github.com/dhess/nixos-yubikey
# Copyright (c) 2019, Drew Hess
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
#     * Neither the name of Drew Hess nor the names of other
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# A set of scripts to help automate some of the steps in Dr Duh's
# YubiKey guide: https://github.com/drduh/YubiKey-Guide.
#
# Most of the heavy lifting can't be automated, because GPG isn't
# easily scripted, but at least these scripts help avoid typos or
# needing to remember cryptic command-line flags.
#
# Note that these scripts use a heuristic to determine the key ID of
# the key you're generating/renewing. It probably won't work if you
# have more than one secret (master) key in your keyring. Caveat
# emptor.
{
  cryptsetup,
  git,
  gnugrep,
  gnupg,
  newt,
  parted,
  symlinkJoin,
  writeShellScriptBin,
  lib,
}: let
  cryptsetupcmd = "${cryptsetup}/bin/cryptsetup";
  gitcmd = "${git}/bin/git";
  gpg = "${gnupg}/bin/gpg";
  grep = "${gnugrep}/bin/grep";
  partedcmd = "${parted}/bin/parted";
  whiptail = "${newt}/bin/whiptail";

  get_keyid = ''
    if [ -f "$GNUPGHOME"/keyid ] ; then
      KEYID=`head "$GNUPGHOME"/keyid`
    else
      echo "$GNUPGHOME/keyid file doesn't exist."
      echo "Write the secret key ID to a file with that name and re-run the script."
      exit 70
    fi
  '';

  opts = ''
    basename=`basename "$0"`

    show_help() {
      echo "Usage: $basename [--help]"
      echo
      echo "--help     Show usage."
    }

    while :; do
        case $1 in
            -h|-\?|--help)
                show_help    # Display a usage synopsis.
                exit
                ;;
            -?*)
                printf 'Unknown option: %s\n' "$1" >&2
                exit 99
                ;;
            *)               # Default case: No more options, so break out of the loop.
                break
        esac
        shift
    done
  '';

  drive-opts = ''
    basename=`basename "$0"`

    show_help() {
      echo "Usage: $basename [--help] DEVICE"
      echo
      echo "--help     Show usage."
      echo "DEVICE     The USB drive device name to operate on."
    }

    while :; do
        case $1 in
            -h|-\?|--help)
                show_help    # Display a usage synopsis.
                exit
                ;;
            -?*)
                printf 'Unknown option: %s\n' "$1" >&2
                exit 99
                ;;
            *)               # Default case: No more options, so break out of the loop.
                break
        esac
        shift
    done

    if [[ $# -ne 1 ]]; then
      echo "Please provide the device name of the USB drive you want to use, e.g., /dev/sda."
      echo
      show_help
      exit 2
    else
      DRIVE="$1"
    fi

    p1="1"
    p2="2"
    encrypted_partition=$DRIVE$p1
    public_partition=$DRIVE$p2

    encrypted_mount="/tmp/encrypted"
    public_mount="/tmp/public"
  '';

  gpg-scripts = {
    gpg-write-keyid = writeShellScriptBin "gpg-write-keyid" ''
      set -e

      ${opts}

      keys=`${gpg} --list-secret-keys | ${grep} "^sec" | ${grep} -o "0x[[:xdigit:]]*"`
      if [ "$keys" ] ; then
        key=`echo "$keys" | tail -1`
        echo "$key" > "$GNUPGHOME"/keyid
        echo "Wrote $key to $GNUPGHOME/keyid"
      else
        echo "Couldn't guess GPG key ID, sorry."
        exit 1
      fi
    '';

    gpg-generate-master-key = writeShellScriptBin "gpg-generate-master-key" ''
      set -e

      ${opts}

      ${gpg} --expert --full-generate-key
    '';

    gpg-add-subkeys = writeShellScriptBin "gpg-add-subkeys" ''
      set -e

      ${opts}

      ${get_keyid}
      ${gpg} --expert --edit-key $KEYID
    '';

    gpg-renew-subkeys = writeShellScriptBin "gpg-renew-subkeys" ''
      set -e

      ${opts}

      ${get_keyid}
      ${gpg} --expert --edit-key $KEYID
    '';

    gpg-add-emails = writeShellScriptBin "gpg-add-emails" ''
      set -e

      ${opts}

      ${get_keyid}
      ${gpg} --expert --edit-key $KEYID
    '';

    gpg-export-keys = writeShellScriptBin "gpg-export-keys" ''
      set -e

      ${opts}

      ${get_keyid}
      ${gpg} --armor --export-secret-keys $KEYID > $GNUPGHOME/mastersub.key
      ${gpg} --armor --export-secret-subkeys $KEYID > $GNUPGHOME/sub.key
    '';

    gpg-git-init = writeShellScriptBin "gpg-git-init" ''
      set -e

      basename=`basename "$0"`

      show_help() {
        echo "Usage: $basename [--help] \"NAME\" EMAIL"
        echo
        echo "--help     Show usage."
        echo "\"NAME\"     Your full name (in quotes)."
        echo "EMAIL      Your Hackworth Ltd email address."
      }

      while :; do
          case $1 in
              -h|-\?|--help)
                  show_help    # Display a usage synopsis.
                  exit
                  ;;
              -?*)
                  printf 'Unknown option: %s\n' "$1" >&2
                  exit 99
                  ;;
              *)               # Default case: No more options, so break out of the loop.
                  break
          esac
          shift
      done

      if [[ $# -ne 2 ]]; then
        echo "Please provide your full name (in quotes) and your Hackworth Ltd email address."
        echo
        show_help
        exit 2
      else
        NAME="$1"
        EMAIL="$2"
      fi

      ${get_keyid}
      cd $GNUPGHOME && ${gitcmd} init
      cd $GNUPGHOME && ${gitcmd} config user.name "$NAME"
      cd $GNUPGHOME && ${gitcmd} config user.email "$EMAIL"
      cd $GNUPGHOME && ${gitcmd} add .
      cd $GNUPGHOME && ${gitcmd} commit -m "Initial commit of key ID $KEYID."
    '';

    gpg-backup-wipe-drive = writeShellScriptBin "gpg-backup-wipe-drive" ''
      set -e

      ${drive-opts}

      if (${whiptail} --title "Wipe $DRIVE?" --defaultno --yesno "Do you really want to securely wipe the USB drive $DRIVE? All data on the drive will be lost." 8 78); then
        echo "Proceeding with secure wipe."
      else
        echo "Aborting secure wipe of $DRIVE."
        exit 1
      fi

      sudo dd if=/dev/urandom of=$DRIVE bs=4M status=progress
    '';

    gpg-backup-partition-drive = writeShellScriptBin "gpg-backup-partition-drive" ''
      set -e

      ${drive-opts}

      if (${whiptail} --title "Partition $DRIVE?" --defaultno --yesno "Do you really want to partition the USB drive $DRIVE? All data on the drive will be lost." 8 78); then
        echo "Proceeding with partitioning."
      else
        echo "Aborting partitioning of $DRIVE."
        exit 1
      fi

      sudo ${partedcmd} --align=opt --script -- $DRIVE \
        mklabel gpt                                    \
        mkpart primary ext2 1MiB 2GiB                  \
        mkpart primary fat32 2GiB -0                   \
        name 1 encrypted                               \
        name 2 public
    '';

    # Note that we can't use bash's nice ${foo} string substition here
    # because it conflicts with Nix's string interpolation.

    gpg-backup-format-drive = writeShellScriptBin "gpg-backup-format-drive" ''
      set -e

      ${drive-opts}

      if (${whiptail} --title "Format $DRIVE?" --defaultno --yesno "Do you really want to format the USB drive $DRIVE? All data on the drive will be lost." 8 78); then
        echo "Proceeding with formatting."
      else
        echo "Aborting formatting of $DRIVE."
        exit 1
      fi

      sudo ${cryptsetupcmd} luksFormat $encrypted_partition
      sudo ${cryptsetupcmd} open $encrypted_partition encrypted
      sudo mkfs.ext4 /dev/mapper/encrypted -L encrypted
      sudo ${cryptsetupcmd} close /dev/mapper/encrypted
      sudo mkfs.vfat -n public $public_partition
    '';

    gpg-backup-sync-keys = writeShellScriptBin "gpg-backup-sync-keys" ''
      set -e
      ${drive-opts}

      echo "Checking whether $GNUPGHOME is clean... "
      pushd $GNUPGHOME 2>&1 1>/dev/null
      if output=$(${gitcmd} status --porcelain) && [ -z "$output" ]; then
        # Clean.
        echo "done."
      else
        echo "Your $GNUPGHOME GPG directory has uncommited changes."
        echo "Please resolve them and then run this command again."
        exit 2
      fi
      popd 2>&1 1>/dev/null

      ${get_keyid}

      gpg-backup-mount $DRIVE

      echo "Checking for an existing backup..."
      if [ -d $encrypted_mount/gnupg ] ; then

        # Existing backup.
        echo "There appears to be one already, we'll use that."
        pushd $encrypted_mount/gnupg 2>&1 1>/dev/null

        echo "Checking whether the existing backup git repo is clean..."
        if output=$(${gitcmd} status --porcelain) && [ -z "$output" ]; then

          # Clean.
          echo "done."

          echo "Merging changes in $GNUPGHOME to the backup git repo..."
          if (${gitcmd} pull $GNUPGHOME); then
            echo "done."
          else
            echo "The backup merge failed!"
            echo
            echo "Please resolve the merge issue. For your convenience, the backup"
            echo "is still mounted at $encrypted_mount/gnupg. If you get stuck, you"
            echo "can run 'git merge --abort' from the $encrypted_mount/gnupg"
            echo "backup directory and start over."
            echo
            echo "When you've resolved the issue and are ready to try a new backup,"
            echo "run 'gpg-backup-unmount $DRIVE' and run this backup script again."
            exit 8
          fi

        else

          # Dirty.
          echo "Your backup git repo has uncommited changes. Please resolve them"
          echo "and then run this command again."
          echo
          echo "For your convenience, the offline backup directory is still mounted"
          echo "at $encrypted_mount/gnupg. When you're finished cleaning it up,"
          echo "run 'gpg-backup-unmount $DRIVE' and then run this script again."
          exit 9
        fi
        popd 2>&1 1>/dev/null

      else

        # First backup to this drive.
        echo "There doesn't appear to be one; creating the initial backup in $encrypted_mount/gnupg..."
        sudo chmod 0777 $encrypted_mount
        ${gitcmd} clone $GNUPGHOME $encrypted_mount/gnupg
        echo "done."

        echo "Fixing permissions on backup directory..."
        chmod 0700 $encrypted_mount/gnupg
        find $encrypted_mount/gnupg -type d -exec chmod 0700 {} \;
        find $encrypted_mount/gnupg -type f -exec chmod 0600 {} \;
        echo "done."
      fi

      echo "Exporting your public key to the public filesystem..."
      ${gpg} --armor --export $KEYID > $public_mount/$KEYID-$(date +%F).txt
      echo "done."

      gpg-backup-unmount $DRIVE
    '';

    gpg-backup-restore-keys = writeShellScriptBin "gpg-backup-restore-keys" ''
      set -e
      ${drive-opts}

      gpg-backup-mount $DRIVE

      echo "Checking for an existing backup..."
      if [ -d $encrypted_mount/gnupg ] ; then

        # Existing backup.
        echo "There appears to be a backup, we'll use that."

        if (${whiptail} --title "Restore GnuPG keys from backup?" --defaultno --yesno "This operation will remove the contents of $GNUPGHOME and restore it from your USB backup drive. Do you want to proceed?" 8 78); then
          echo "Proceeding with restore."
          pkill gpg-agent || true
          rm -rf $GNUPGHOME

          echo "Cloning the backup to $GNUPGHOME..."
          ${gitcmd} clone $encrypted_mount/gnupg $GNUPGHOME
          echo "done."

          echo "Fixing permissions on restored directory..."
          chmod 0700 $GNUPGHOME
          find $GNUPGHOME -type d -exec chmod 0700 {} \;
          find $GNUPGHOME -type f -exec chmod 0600 {} \;
          echo "done."

        else
          echo "Aborting the restore."
        fi
      else
        echo "There doesn't appear to be a gpg backup on $DRIVE. Aborting the restore."
      fi

      gpg-backup-unmount $DRIVE
    '';

    gpg-backup-mount = writeShellScriptBin "gpg-backup-mount" ''
      set -e

      ${drive-opts}

      echo "Opening encrypted filesystem..."
      sudo ${cryptsetupcmd} open $encrypted_partition encrypted
      echo "done."

      echo "Mounting encrypted filesystem on $encrypted_mount..."
      sudo mkdir $encrypted_mount
      sudo mount /dev/mapper/encrypted $encrypted_mount
      echo "done."

      echo "Mounting public filesystem on $public_mount..."
      sudo mkdir $public_mount
      sudo mount -o rw,umask=0000 $public_partition $public_mount
      echo "done."
    '';

    gpg-backup-unmount = writeShellScriptBin "gpg-backup-unmount" ''
      set -e

      unmount() {
        echo "Unmounting $1..."
        sudo sync
        sudo sync
        sudo umount $1
        echo "done."

        echo "Removing mount point $1..."
        sudo rmdir $1
        echo "done."
      }

      ${drive-opts}

      if [ -d $encrypted_mount ] ; then
        unmount $encrypted_mount
        echo "Closing encrypted filesystem..."
        sudo ${cryptsetupcmd} close /dev/mapper/encrypted
        echo "done."
      else
        echo "The encrypted backup filesystem doesn't appear to be mounted, skipping."
      fi

      if [ -d $public_mount ] ; then
        unmount $public_mount
      else
        echo "The public backup filesystem doesn't appear to be mounted, skipping."
      fi
    '';
  };
in
  symlinkJoin {
    name = "gpg-scripts";
    paths = lib.attrValues gpg-scripts;
  }

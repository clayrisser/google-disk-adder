#!/bin/bash

echo "   ____                   _        ____  _     _         _       _     _           "
echo "  / ___| ___   ___   __ _| | ___  |  _ \(_)___| | __    / \   __| | __| | ___ _ __ "
echo " | |  _ / _ \ / _ \ / _\` | |/ _ \ | | | | / __| |/ /   / _ \ / _\` |/ _\` |/ _ \ '__|"
echo " | |_| | (_) | (_) | (_| | |  __/ | |_| | \__ \   <   / ___ \ (_| | (_| |  __/ |   "
echo "  \____|\___/ \___/ \__, |_|\___| |____/|_|___/_|\_\ /_/   \_\__,_|\__,_|\___|_|   "
echo "                    |___/                                                          "
echo

# Setup
echo "This program adds a Google Cloud Disk to a Google Compute Engine"
if [ $(whoami) = "root" ]; then # If Root
  echo
  read -p "Enter the name of the disk you would like to add: " DiskName
  echo
  read -p "Enter mount location. Leave blank to mount at /mnt/"$DiskName": " MountLocation
  if [ ! $MountLocation ]; then
    MountLocation="/mnt/"$DiskName
  fi
  if [ -d $MountLocation ]; then
    echo
    echo "This mount location already exists."
    read -p "Would you like to merge the contents of this directory? (Y|n): " MergeDirectory
    if [ ! $MergeDirectory ]; then
      MergeDirectory="y"
    fi
  fi
  echo
  read -p "Would you like "$DiskName" to mount on boot? (Y|n): " MountOnBoot
  if [ ! $MountOnBoot ]; then
    MountOnBoot="y"
  fi
  echo
  echo "WARNING: This operation will format "$DiskName"."
  read -p "Enter the name of the disk to verify you wish to continue: " Continue

  if [ $Continue = $DiskName ]; then # If Continue

    # Mount Disk
    echo "> Formatting "$DiskName" as Ext4 filesystem"
    mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-$DiskName
    if [ ${MergeDirectory,} = "y" ]; then # Merge Directory
      TempLocation="/mnt/"$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
      mkdir $TempLocation
      echo "> Mounting to temporary location"
      mount -o discard,defaults /dev/disk/by-id/google-$DiskName $TempLocation
      chmod a+w $TempLocation
      echo "> Merging with "$MountLocation
      echo "cp "$MountLocation" "$TempLocation
      cp $MountLocation $TempLocation
      rm -rf $MountLocation
      echo "> Mounting to "$MountLocation
      mkdir $MountLocation
      mount -o discard,defaults /dev/disk/by-id/google-$DiskName $MountLocation
      chmod a+w $MountLocation
      echo "> Unmouting temporary location"
      umount $TempLocation
    else
      if [ -d $MountLocation ]; then
        echo "> Removing "$MountLocation
        rm -rf $MountLocation
      fi
      echo "> Mounting to "$MountLocation
      mkdir $MountLocation
      mount -o discard,defaults /dev/disk/by-id/google-$DiskName $MountLocation
      chmod a+w $MountLocation
    fi

    # Add disk to /etc/fstab for mouting on boot
    if [ ${MountOnBoot,} = "y" ]; then 
      echo "> Adding disk to /etc/fstab for mouting on boot."
      echo "/dev/disk/by-id/google-"$DiskName" "$MountLocation" ext4 discard,defaults 1 1" | tee -a /etc/fstab
    fi

  fi #End Continue

else #Not Root
echo "This command must be run as root."

fi #End Root
echo "Exiting"

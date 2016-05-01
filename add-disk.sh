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

    # Add Disk
    echo "> Formatting as Ext4 filesystem."
    mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-$DiskName
    echo "> Mounting disk."
    mkdir $MountLocation
    mount -o discard,defaults /dev/disk/by-id/google-$DiskName $MountLocation
    echo "> Disk mounted at "$MountLocation
    chmod a+w $MountLocation

    # Set as /home
    if [ ${HomeDirectory,} = "y" ]; then
      echo "> Copying home directory to disk."
      cp /home $MountLocation
      echo "> Removing current home directory."
      rm -rf /home
      echo "> Mounting to /home directory."
      mkdir /home
      mount -o discard,defaults /dev/disk/by-id/google-$DiskName /home
      echo "> Unmounting /mnt/"$MountLocation
      unmount /mnt/$MountLocation
    fi

    # Add disk to /etc/fstab for mouting on boot
    if [ ${MountOnBoot,} = "y" ]; then 
      echo "> Adding disk to /etc/fstab for mouting on boot."
      if [ ${HomeDirectory,} = "y" ]; then
        echo "/dev/disk/by-id/google-"$DiskName" /home ext4 discard,defaults 1 1" | tee -a /etc/fstab
      else
        echo "/dev/disk/by-id/google-"$DiskName" "$MountLocation" ext4 discard,defaults 1 1" | tee -a /etc/fstab
      fi
    fi

  fi #End Continue

else #Not Root
echo "This command must be run as root."

fi #End Root
echo "Exiting"

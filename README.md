# Google Disk Adder
Adds a Google Cloud Disk to a Google Compute Engine.

###### Example use cases for Google Disk Adder:
1. Create a separate /home partition.
2. Add additional backup and storage partitions.

Google Disk Adder allows you to choose any location in your Google Compute Engine for mounting a Google Cloud Disk. If the mounting location already contains files, Google Disk Adder gives you the option to merge the files or overwrite them with the Google Disk. Google Disk Adder also gives you the option to automatically mount the disk when the compute engine restarts. If you are using Google Disk Adder to create a separate /home partition, it is highly recommended that you choose to allow this to merge the /home directory with the Google Cloud Disk and automaticlly mount the disk when the computer restarts.

## Usage
1. Add a persistent disk to your instance.
  * Learn how to do that <a href="https://cloud.google.com/compute/docs/disks/add-persistent-disk#create_disk" target"_blank">HERE</a>.
2. Run the following commands.
```
cd /tmp
wget https://raw.githubusercontent.com/jamrizzi/google-disk-adder/master/add-disk.sh
sudo chmod +x add-disk.sh
sudo ./add-disk.sh
```

## [Buy Me Coffee](http://jamrizzi.com/buy-me-coffee)
A ridiculous amount of coffee was consumed in the process of building this project. [Add some fuel](http://jamrizzi.com/buy-me-coffee) if you'd like to keep me going!


## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Changelog
Take a peek at the [CHANGELOG](https://github.com/jamrizzi/google-disk-adder/blob/master/CHANGELOG.md).

## License
[GNU Public License Version 3](https://raw.githubusercontent.com/jamrizzi/google-disk-adder/master/LICENSE)

This is a fork of the [Ubuntu Preseed ISO Generator](https://github.com/covertsh/ubuntu-preseed-iso-generator) modified to run on macOS.

# Ubuntu Preseed ISO Generator for macOS
The script runs on macOS and will generate an ISO image for an automated Ubuntu 20.04 desktop installations that can be copied to a bootable USB flash drive. This script uses the traditional preseed method.

---

### Modifications for macOS

Changes to allow the script to execute on macOS include:

#### Required Utilities

If Homebrew is installed, offer to install the following utilities if they're not available:

- `curl`
- `gpg`
- `sed`
- `xorriso`

#### Required Binaries
Use `stat` instead of `realpath` as the latter is not readibly available
on macOS.

#### Integrity Check Using GPG
Set the correct ownership and permissions on the `$HOME/.gnupg` directory
required by `gpg`. Create it first if it doesn't exist.

```
/
|-- Users/
    |-- $USER/
        |-- .gnupg/          $USER:staff rwx------ [700]
            |-- file         $USER:staff rw------- [600]
            |-- directory/   $USER:staff rwx------ [700]
                |-- file     $USER:staff rw------- [600]
```


#### Creating a Bootable Hybrid ISO Image

Create the MBR template file named `isohdpfx.bin` requied by `xorriso`
to create a hybrid ISO image. This is achieved by copying the first 512 bytes of the downloaded Ubuntu Desktop ISO image using `dd`. See [Booting USB with custom iso file](https://askubuntu.com/a/980340).

##### Tested with
- macOS Monterey 12.3.1 host
- Ubuntu Desktop 20.04 ISO image

---

### Behavior

Check out the usage information below for arguments. The basic idea is to take an unmodified Ubuntu ISO image, extract it, add some kernel command line parameters and a preseed file, then repack the data into a new ISO. Creating the preseed file itself is outside the scope of this tool.

There is an example preseed file ```example.seed``` in this repository which will install Ubuntu using US English settings and UTC time zone with a user named "User" and password "ubuntu". You could modify that file to create your own custom configuration. Unlike the server version of this script, there is currently no way to provide the preseed configuration on a separate volume during the installation - it must be baked into the ISO image.

This script can use an existing ISO image or download the latest daily 64-bit image from the Ubuntu project. Using a fresh ISO speeds things up because there won't be as many packages to update during the installation.

By default, the source ISO image is checked for integrity and authenticity using GPG. This can be disabled with ```-k```.

### Requirements
Tested on a host running Ubuntu 20.04.1.
- Utilities required:
    - ```p7zip-full```
    - ```mkisofs``` or ```genisoimage```

### Usage
```
Usage: ubuntu-preseed-iso-generator.sh [-h] [-k] [-v] [-p preseed-configuration-file] [-s source-iso-file] [-d destination-iso-file]

💁 This script will create fully-automated Ubuntu 20.04 Focal Fossa installation media.

Available options:

-h, --help          Print this help and exit
-v, --verbose       Print script debug info
-p, --preseed       Path to preseed configuration file.
-k, --no-verify     Disable GPG verification of the source ISO file. By default SHA256SUMS-<current date> and
                    SHA256SUMS-<current date>.gpg in <script directory> will be used to verify the authenticity and integrity
                    of the source ISO file. If they are not present the latest daily SHA256SUMS will be
                    downloaded and saved in <script directory>. The Ubuntu signing key will be downloaded and
                    saved in a new keyring in <script directory>
-s, --source        Source ISO file. By default the latest daily ISO for Ubuntu 20.04 will be downloaded
                    and saved as <script directory>/ubuntu-original-<current date>.iso
                    That file will be used by default if it already exists.
-d, --destination   Destination ISO file. By default <script directory>/ubuntu-preseed-<current date>.iso will be
                    created, overwriting any existing file.
```

### Example
```
user@testbox:~$ bash ubuntu-preseed-iso-generator.sh -p example.seed -d ubuntu-preseed-example.iso
[2021-03-13 10:05:10] 👶 Starting up...
[2021-03-13 10:05:10] 📁 Created temporary working directory /tmp/tmp.rrehvj78Bk
[2021-03-13 10:05:10] 🔎 Checking for required utilities...
[2021-03-13 10:05:10] 👍 All required utilities are installed.
[2020-12-23 14:06:07] 🌎 Downloading current daily ISO image for Ubuntu 20.04 Focal Fossa...
[2020-12-23 14:08:01] 👍 Downloaded and saved to /home/user/ubuntu-original-2021-03-13.iso
[2020-12-23 14:08:01] 🌎 Downloading SHA256SUMS & SHA256SUMS.gpg files...
[2020-12-23 14:08:02] 🌎 Downloading and saving Ubuntu signing key...
[2020-12-23 14:08:02] 👍 Downloaded and saved to /home/user/843938DF228D22F7B3742BC0D94AA3F0EFE21092.keyring
[2020-12-23 14:08:02] 🔐 Verifying /home/user/ubuntu-original-2021-03-13.iso integrity and authenticity...
[2020-12-23 14:08:09] 👍 Verification succeeded.
[2020-12-23 14:08:09] 🔧 Extracting ISO image...
[2021-03-13 10:05:23] 👍 Extracted to /tmp/tmp.rrehvj78Bk
[2021-03-13 10:05:23] 🧩 Adding preseed parameters to kernel command line...
[2021-03-13 10:05:23] 👍 Added parameters to UEFI and BIOS kernel command lines.
[2021-03-13 10:05:23] 🧩 Adding preseed configuration file...
[2021-03-13 10:05:23] 👍 Added preseed file
[2021-03-13 10:05:23] 👷 Updating /tmp/tmp.rrehvj78Bk/md5sum.txt with hashes of modified files...
[2021-03-13 10:05:23] 👍 Updated hashes.
[2021-03-13 10:05:23] 📦 Repackaging extracted files into an ISO image...
[2021-03-13 10:05:35] 👍 Repackaged into /home/user/ubuntu-preseed-example.iso
[2021-03-13 10:05:35] ✅ Completed.
[2021-03-13 10:05:35] 🚽 Deleted temporary working directory /tmp/tmp.rrehvj78Bk
```

Now you can boot your target machine using ```ubuntu-preseed-example.iso``` and it will automatically install Ubuntu using the configuration from ```example.seed```.

### Thanks
This script is based on [this](https://betterdev.blog/minimal-safe-bash-script-template/) minimal safe bash template, and steps found in [this](https://askubuntu.com/questions/806820/how-do-i-create-a-completely-unattended-install-of-ubuntu-desktop-16-04-1-lts) Ask Ubuntu answer.


### License
MIT license.

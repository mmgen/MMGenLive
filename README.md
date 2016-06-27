## MMGenLive

MMGenLive is a fully functional Linux system on a USB stick with the MMGen
online/offline Bitcoin wallet and related programs preinstalled.

MMGenLive gives you, out of the box:

* A completely installed, upgradeable and configurable Ubuntu Linux system
* Full disk encryption (entire filesystem is read/write)
* The latest Bitcoin Core
* The MMGen wallet system and documentation

MMGenLive can be used both as an offline signing wallet and as an online
tracking/transacting wallet with a full or pruned blockchain.

There are two ways to install MMGenLive:

* download a prebuilt binary and copy it to a USB stick, or
* build the system yourself using the automated shell script (Linux-only).

### Install MMGenLive from a prebuilt binary:
* Download the latest \*system.tgz file from the binaries directory.
* Insert a USB stick into your computer.

> #### If you’re running Linux:

> * Determine your USB stick’s device name.  This can be done with the command
> `dmesg | tail`, for example.
> * Execute the command `zcat *.system.tgz > /dev/sdX`, replacing `sdX` with
>   your USB stick’s device name.

> #### If you’re running Windows:

> * Unzip the \*system.tgz file using an archiving program such as WinZIP or
>   PKZIP.
> * Follow [these instructions][1], replacing “SD card” with “USB stick”
>   and “image” with the file you just unzipped.

* Reboot your computer from the USB stick.  You may have to enter your BIOS boot
  menu to do this.

### Install MMGenLive using the automated shell script (Linux only):

* Clone the mmgen and MMGenLive repositories:

            git clone https://github.com/mmgen/mmgen.git
            git clone https://github.com/mmgen/MMGenLive.git

* Download the latest extras files from the extras directory (currently
  Ubuntu xenial) and place them in the MMGenLive repository root.

* Build and install the MMGenLive system:

            cd MMGenLive
            sudo ./build_system.sh

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

[**Forum**][4] |
[PGP Public Key][5] |
Donate: 15TLdmi5NYLdqmtCqczUs5pBPkJDXRs83w

[1]: https://www.raspberrypi.org/documentation/installation/installing-images/windows.md
[4]: https://bitcointalk.org/index.php?topic=567069.0
[5]: https://github.com/mmgen/mmgen/wiki/MMGen-Signing-Key

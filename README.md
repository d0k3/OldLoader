# OldLoader
Boot FIRMs from old entrypoints.

## WARNING!
**Do not boot Luma, or any FIRM CFW, using this loader!** \
This is meant for developers and advanced users _only._ Support for this is not expected from the people making existing FIRM applications and CFW's; _you're on your own here._

Some CFWs assume that the environment that they're being bootstrapped from, is either A9LH and old entrypoints, _or_ B9S/sighax proper. \
This is a sort of hybrid of both, and may lead to unhandled situations such as missing FIRM protection, or the use of incorrect keys for loading from CTRNAND, because using this method is inconsistent with some hard assumptions about the bootstrap environment. \
Loading such a CFW using this, at best, will probably not work; at worst, it **will brick your console!** You will then need a hardmod or other method of writing system NAND, to repair that.

## Instructions
Copy the FIRM of your choice to your SD card as `boot.firm`, then run OldLoader via the entrypoint of your choice (requires copying / setting up more stuff, ofc), done. Simple, no? Also keep in mind, again, **this is for _advanced users_ only.** \
Everyone else just refer to the Guide and get up to date on your 3DS hacking.

## Credits
* **Normmatt**, for sdmmc.c / sdmmc.h
* **Cha(N)**, **Kane49**, and all other FatFS contributors for FatFS
* **Wolfvak** for providing the A9LH chainloader and being a great guy
* **Gelex** for being of great help on countless occasions
* The fine folks on **freenode #Cakey**
* All **[3dbrew.org](https://www.3dbrew.org/wiki/Main_Page) editors**
* Everyone I possibly forgot, if you think you deserve to be mentioned, just contact me!

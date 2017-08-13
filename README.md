# OldLoader
Boot FIRMs from old entrypoints.

## Instructions
Copy the FIRM of your choice to your SD card as `boot.firm`, then run OldLoader via the entrypoint of your choice (requires copying / setting up more stuff, ofc), done. Simple, no? Also keep in mind this is for advanced users only. Everyone else just refer to the Guide and get up to date on your 3DS hacking.

## What this works with
OldLoader does not provide a proper boot9strap environment (regarding AES key and TWL setups) and also does not identify as such. For this reason, it will not run software that checks for (and requires!) a proper boot9strap environment, among those CFWs. It is really only tested to work properly with [GodMode9](https://github.com/d0k3/GodMode9), and it may or may not work with more stuff later (_on your own risk, users_). To the developers: _Edits to the source that would fake a boot9strap environment are discouraged_, as running b9s-only payloads the OldLoader-way may pose a significant bricking risk to the users.

## Credits
* **Normmatt**, for sdmmc.c / sdmmc.h
* **Cha(N)**, **Kane49**, and all other FatFS contributors for FatFS
* **Wolfvak** for providing the FIRM chainloader and being a great guy
* **Al3x_19m** for providing his assistiance in testing this
* **Gelex** for being of great help on countless occasions
* The fine folks on **freenode #Cakey**
* All **[3dbrew.org](https://www.3dbrew.org/wiki/Main_Page) editors**
* Everyone I possibly forgot, if you think you deserve to be mentioned, just contact me!

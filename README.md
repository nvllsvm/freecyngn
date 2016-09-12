# freecyngn
A small tool to remove some proprietary parts from CyanogenMod.

freecyngn removes the following components which either contain or require
proprietary components of Google:

- Browser (Gello)
- CyanogenSetupWizard
- LockClock
- TimeService


## Usage

### Clean install:
In order for the home button and quick settings to function, freecyngn needs to set a value in the CMSettings database. However, that database does not exist until after the initial boot to Android.

1. Boot to recovery.
2. Wipe `/data` and `/system`.
3. Install CyanogenMod.
4. Install freecyngn.
5. Boot to Android. This will populate `/data` with the CMSettings database.
6. Reboot to recovery.
7. Mount `/data`.
8. Install freecyngn again. It's already installed, but installing again will trigger the script to run once more. The CMSettings database will then be updated to restore the aforementioned functionality.

### Dirty install:
1. Boot to recovery.
2. Install freecyngn.

After this, freecyngn will never have to be installed again. It will automatically apply each time a CyanogenMod update is installed. However make sure to regularly check for freecyngn updates, as CyanogenMod may change some things.


## Build Instructions
You should be able to download the last release and replace the updater-script and 20-freecyngn.sh with the latest.

If you need to rebuild the updater-binary, or would like more information, see this wiki:
http://wiki.cyanogenmod.org/w/Doc:_About_Edify


## License
freecyngn is licensed under WTFPL, see LICENSE

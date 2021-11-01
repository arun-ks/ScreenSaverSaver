# ScreenSaver Saver



### Keep computer unlocked by ensuring Screen Saver is not activated.

Handy tool for users whose Screen Saver Settings are controlled by corporate Administrators.

**IMPORTANT: Use this only when you can keep an eye on your computer, to avoid unauthorized access**

## How does it work ?
The script will move the mouse few pixels after regular (configurable) intervals to keep the screensaver at bay.

If the screen saver has been kept awake for a configurable consecutive iterations, the script will exit.

## Pre-requisite & Installation guide
You will need [Autohotkey](https://www.autohotkey.com/) installed to execute the .ahk script.
Alternately, you can used the compiled .exe file on windows.

To install, download all the files in this repository.
Ensure ScreenSaverSaver.ahk, ScreenSaverSaver.exe & ScreenSaverSaver.ini are in same folder. 
ScreenSaverSaver.ico should be in "resources" subfolder.

That's it ! 
Execute .ahk or .exe file when you need to keep the system unlocked.

## Configuration Guide

Update following settings in ScreenSaverSaver.ini file

| Parameter |  Default value | Description |
| ------ | ------ | ----- |
|KeepAwakeMinutes| 10 | Minutes after which Mouse should be moved. Keep this value a few minutes lower than screen saver timeout |
|KeepAwakeIterations| 12 | After keeping the screensaver awake for this many iterations, the script will exit |


Use the **KeepAwakeIterations** setting to ensure that the devices are not compromized.


![Icon](https://github.com/arun-ks/ScreenSaverSaver/main/resources/ScreenSaverSaver.ico?raw=true)

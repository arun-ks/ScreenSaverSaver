# ScreenSaver Saver/ Mouse Jiggler

![Tray Icon](./resources/ScreenSaverSaver.ico)

### Keep computer unlocked by ensuring Screen Saver is not activated.

Handy tool for users whose Screen Saver Settings are controlled by corporate Administrators.

**IMPORTANT: Use this only when you can keep an eye on your computer, to avoid unauthorized access**

## How does it work ?
After regular configurable intervals(`KeepAwakeMaxMinutes`), the application checks the mouse's location. To avoid detection, the check is done 3-10 seconds less than `KeepAwakeMaxMinutes`.

If the mouse has not moved during this interval, the script will do the following to keep the screensaver at bay.

-  Move the mouse for random(<5) seconds, using cubic [easing in/out](https://easings.net/) to mimic a natural hand movement
-  Send key strokes for ALT+TAB (move to next open program), then SHIFT+TAB (move to previous open program). Each keystroke would be done after random time to mimic natural use.

If the screen saver has been kept awake for a configurable consecutive iterations(`KeepAwakeIterations`), the script will exit.

## Pre-requisite & Installation guide
You will need [Autohotkey](https://www.autohotkey.com/) installed to execute the .ahk script.
Alternately, you can used the compiled .exe file on windows.

To install, download all the files in this repository.
Ensure ScreenSaverSaver.ahk, ScreenSaverSaver.exe & ScreenSaverSaver.ini are in same folder. 
ScreenSaverSaver.ico should be in "resources" subfolder.

That's it ! 
Execute .exe file or .ahk(if you have [Autohotkey](https://www.autohotkey.com/) installed) when you need to keep the system unlocked.

## Configuration Guide

Update following settings in ScreenSaverSaver.ini file. In case the file is missing, the application will create the file with default values.

| Parameter |  Default value | Description |
| ------ | ------ | ----- |
|KeepAwakeMaxMinutes| 10 | Minutes after which Mouse should be moved. Keep this value a lesser than half of screen saver timeout |
|KeepAwakeIterations| 12 | After keeping the screensaver awake for this many iterations, the script will exit |
|ShowDebugMesgFlag| 0 | If the value is non-zero, the tool will show debug messages |


Use the **KeepAwakeIterations** setting to ensure that the devices are not compromized.

## Debug Messages 
The script keeps track of every time the script moved the mouse & swapped screens. This can be seen using the "Show logs.." option in the Tray Menu.

Also, when the script finally terminates, it would also display this log.

## Screenshots
| Startup Mesg |
| -------- | 
| ![Startup](./resources/ProgStartLogMesg.jpg) | 



| Termination screen | Tray Menu |
| ------ |------ |
| ![End](./resources/ProgramTerminateScreen.jpg) |  ![End](./resources/ProgramTrayMenu.jpg) |



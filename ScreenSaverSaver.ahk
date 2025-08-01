#SingleInstance force
#NoEnv

; Purpose: Avoid Screen Saver from starting by moving mouse (in a manner similar to human movements) & pressing few buttons every few minutes.

; Setup Tray icon, menu items & read configuration parameters
IfExist %A_ScriptDir%/resources/ScreenSaverSaver.ico
{
    Menu, Tray, Icon, %A_ScriptDir%/resources/ScreenSaverSaver.ico, , 0
}
Menu, Tray, Tip, Screen Saver Saver
Menu, Tray,Add
Menu, Tray,Add,Show Configuration ...,SHOWCONFIG
Menu, Tray,Add,Show logs ...,SHOWLOGS

KeepAwakeMaxMinutes := GetConfigValueFromIni("Settings","KeepAwakeMaxMinutes", 5) ; Duration(in Minutes) after which mouse should move to avoid Screen Saver. Make it lesser than system defined screensaver actication time.
KeepAwakeIterations := GetConfigValueFromIni("Settings","KeepAwakeIterations", 24) ; After keeping the screensaver awake for this many iterations, the script will exit
global ShowDebugMesgFlag
ShowDebugMesgFlag := GetConfigValueFromIni("Settings","ShowDebugMesgFlag", 0)      ; If the value is non-zero, the tool will show debug messages

VanishingDebugMesg("Starting app with params KeepAwakeMaxMinutes=" . KeepAwakeMaxMinutes . ", KeepAwakeIteration=" . KeepAwakeIterations . ", and ShowDebugMesgFlag=" . ShowDebugMesgFlag , 	  4)  ;
debugLogString = % "Using KeepAwake Mins = " . KeepAwakeMaxMinutes . ", Iterations= " . KeepAwakeIterations . "`n"

CoordMode, Mouse, Screen
MouseGetPos, prevX, prevY
countOfKeepAwakeIterations = 0
totalKeepAwakeMilliSec = 0

Loop {
    currKeepAwakeTimerMilliSec := KeepAwakeMaxMinutes * 60 * 1000 - Random(3000, 10000)   ; Time in milli seconds with 3-10 sec randomness
    Sleep, % currKeepAwakeTimerMilliSec   

    MouseGetPos, currX, currY
    If (1 = 1 or currX = prevX and currY = prevY) {                           ; Mouse has not moved, do what is needed !
        countOfKeepAwakeIterations := countOfKeepAwakeIterations + 1
        totalKeepAwakeMilliSec := totalKeepAwakeMilliSec + currKeepAwakeTimerMilliSec

        VanishingDebugMesg("Mouse was not moved for last " . Round(totalKeepAwakeMilliSec / 60000, 2) . " minutes. It will move now #" . countOfKeepAwakeIterations , 3)  ;
        FormatTime, currTime, Time, d-MMM,HH:mm:ss
        debugLogString := debugLogString . " #(" . countOfKeepAwakeIterations . ")@(" . currTime . ")"

        ; Smooth mouse movement with acceleration/deceleration
        moveX := Random(-50, 150)
        moveY := Random(-50, 150)
        ; duration := Random(1000, 5000)      
        ; steps := duration / 100
        distance := Sqrt(moveX**2 + moveY**2)
        steps := Max(15, Round((duration * distance) / 3000))        
        
        Loop, %steps% {   ; Cubic easing in/out for more natural movement
            t := A_Index/steps            
            easedT := t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
            MouseMove, currX + (moveX * easedT), currY + (moveY * easedT), 0
            Sleep, % Round(duration / steps)
        }        
        MouseMove, Random(-5, 5), Random(-5, 5), 0, R                 ; Small random adjustment after main movement
        MouseGetPos, prevX, prevY
                
        Sleep, Random(50, 300)
        
        ; Alt+Tab , then Alt+Shift+Tab
        keys := ["{Alt Down}","{Tab}","{Shift Down}","{Tab}","{Shift Up}","{Alt Up}"]
        for each, key in keys {
             Sleep, % Random(50, 200)
             SendInput, % key
        }
     }
     else {                                                          ; There is no need to keep Awake.
        prevX := currX
        prevY := currY
        countOfKeepAwakeIterations = 0
        totalKeepAwakeMilliSec = 0
     }

    if( countOfKeepAwakeIterations >= KeepAwakeIterations) {                      ; If screen saver has been avoided KeepAwakeIterations times, then exit the script
        FormatTime, currTime, Time, MMM d, hh:mm:ss
        debugLogString := % "ScreenSaver Saver exits after " . KeepAwakeIterations . " consecutive iterations at " . currTime . "`n" . debugLogString
        Gosub SHOWLOGS
        ExitApp
    }
}


; Purpose: Flash message <text> for <displaySeconds> on the screen
VanishingDebugMesg(text, displaySeconds){
	if ( ShowDebugMesgFlag == 0 )
	   return

  TrayTip , ScreenSaverSaver, % text , displaySeconds*2, 0x20
	Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
	Gui, Color, ffffff                                ;changes background color
	Gui, Font, 000000 s18 wbold, Verdana              ;changes font color, size and font

  seconds2Sleep := displaySeconds
	while seconds2Sleep > 0      {
        Gui, Add, Text, x0 y0, %text%                  ;the text to display
	      Gui, Show, NoActivate, Xn: 0, Yn: 0
        seconds2Sleep := seconds2Sleep - 1
        Sleep, 1000
    }
	Gui, Destroy
}


; Purpose : Read key from .ini File, and if the data does not exists write the default value
GetConfigValueFromIni(section, key, default)
{
        IniRead,IniVal,%A_ScriptDir%/ScreenSaverSaver.ini,%section%,%key%
        if IniVal = ERROR
        {
                IniWrite,%default%,%A_ScriptDir%/ScreenSaverSaver.ini,%section%,%key%
                IniVal := default
        }
        return IniVal
}

; Simplified Random function in C-style
Random(min, max) {
    Random, r, min, max
    return r
}

SHOWCONFIG:
  Run, %A_ScriptDir%/ScreenSaverSaver.ini
return

SHOWLOGS:
  MsgBox, 64,, % debugLogString
return

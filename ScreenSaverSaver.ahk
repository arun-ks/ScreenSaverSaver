#SingleInstance force
#NoEnv

; Avoid Screen Saver from starting by slightly moving mouse & press few buttons every few minutes.

IfExist %A_ScriptDir%/resources/ScreenSaverSaver.ico 
{
    Menu, Tray, Icon, %A_ScriptDir%/resources/ScreenSaverSaver.ico, , 0
    Menu, Tray,Add,Show Configuration...,SHOWCONFIG
}

KeepAwakeMinutes := GetConfigValueFromIni("Settings","KeepAwakeMinutes", 10)       ; Duration(in Minutes) after which mouse should move to avoid Screen Saver. Make it lesser than system defined screensaver actication time.
KeepAwakeIterations := GetConfigValueFromIni("Settings","KeepAwakeIterations", 12) ; After keeping the screensaver awake for this many iterations, the script will exit
global ShowDebugMesgFlag
ShowDebugMesgFlag := GetConfigValueFromIni("Settings","ShowDebugMesgFlag", 0)      ; If the value is non-zero, the tool will show debug messages

VanishingDebugMesg("Starting app with params KeepAwakeMinutes=" . KeepAwakeMinutes . ", KeepAwakeIteration=" . KeepAwakeIterations . ", and ShowDebugMesgFlag=" . ShowDebugMesgFlag , 	  4)  ;

CoordMode, Mouse, Screen
MouseGetPos, prevX, prevY   
countOfSkips = 0

Loop {
    Sleep, % KeepAwakeMinutes * 60 * 1000        ; Time in milli seconds.
   
    MouseGetPos, currX, currY   
    If (currX = prevX and currY = prevY) {       ; Mouse has not moved, do what is needed !
        MouseMove, 10, 10, , R
        Sleep, 100
        MouseMove, -10, -10, , R
        
        SendInput, {Ctrl Down}{Tab}{Ctrl Up}     ; Press CTRL+TAB .. then CTRL+SHIFT+TAB
        sleep, 100
        SendInput, {Ctrl Down}{Shift Down}{Tab}{Shift Up}{Ctrl Up}
        
        countOfSkips := countOfSkips + 1
        VanishingDebugMesg("Skipping Screen saver #" . countOfSkips , 	  5)  ;
    }
     else {
        prevX := currX
        prevY := currY
        countOfSkips = 0
     }
     
     if( countOfSkips >= KeepAwakeIterations) {
        FormatTime, currTime, Time, ddd MMMM d, hh:mm:ss 
        MsgBox, 0,, % "Stopping ScreenSaver Saver after " . KeepAwakeIterations . " consecutive iterations at " . currTime
        break
      }
}

VanishingDebugMesg(text, displaySeconds){
	if ( ShowDebugMesgFlag == 0 ) 
	   return
	   
	Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
	Gui, Color, ffffff ;changes background color
	Gui, Font, 000000 s18 wbold, Verdana ;changes font color, size and font

    seconds2Sleep := displaySeconds
	while seconds2Sleep > 0      {
        Gui, Add, Text, x0 y0, %text%  ;the text to display
	    Gui, Show, NoActivate, Xn: 0, Yn: 0
        seconds2Sleep := seconds2Sleep - 1
        Sleep, 1000
    } 
	Gui, Destroy
}


; Read from .ini File, and if the data does not exists write the default value
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

SHOWCONFIG:
  Run, %A_ScriptDir%/ScreenSaverSaver.ini
Return
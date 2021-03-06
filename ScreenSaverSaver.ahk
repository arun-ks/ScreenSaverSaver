#SingleInstance force
#NoEnv

; Purpose: Avoid Screen Saver from starting by slightly moving mouse & pressing few buttons every few minutes.


; Setup Tray icon, menu items & read configuration parameters
IfExist %A_ScriptDir%/resources/ScreenSaverSaver.ico 
{
    Menu, Tray, Icon, %A_ScriptDir%/resources/ScreenSaverSaver.ico, , 0
}
Menu, Tray, Tip, Screen Saver Saver
Menu, Tray,Add
Menu, Tray,Add,Show Configuration...,SHOWCONFIG
Menu, Tray,Add,Show logs ...,SHOWLOGS

KeepAwakeMinutes := GetConfigValueFromIni("Settings","KeepAwakeMinutes", 10)       ; Duration(in Minutes) after which mouse should move to avoid Screen Saver. Make it lesser than system defined screensaver actication time.
KeepAwakeIterations := GetConfigValueFromIni("Settings","KeepAwakeIterations", 12) ; After keeping the screensaver awake for this many iterations, the script will exit
global ShowDebugMesgFlag
ShowDebugMesgFlag := GetConfigValueFromIni("Settings","ShowDebugMesgFlag", 0)      ; If the value is non-zero, the tool will show debug messages


VanishingDebugMesg("Starting app with params KeepAwakeMinutes=" . KeepAwakeMinutes . ", KeepAwakeIteration=" . KeepAwakeIterations . ", and ShowDebugMesgFlag=" . ShowDebugMesgFlag , 	  4)  ;
debugLogString = % "Using KeepAwake Mins = " . KeepAwakeMinutes . ", Iterations= " . KeepAwakeIterations . "`n" 

CoordMode, Mouse, Screen
MouseGetPos, prevX, prevY   
countOfSkips = 0
Loop {
    Sleep, % KeepAwakeMinutes * 60 * 1000        ; Time in milli seconds.
   
    MouseGetPos, currX, currY   
    If (currX = prevX and currY = prevY) {                           ; Mouse has not moved, do what is needed !
        countOfSkips := countOfSkips + 1
        VanishingDebugMesg("Mouse was not moved for last " . KeepAwakeMinutes . " minutes. It will move now #" . countOfSkips , 5)  ;
        
        FormatTime, currTime, Time, d-MMM,hh:mm:ss 
        debugLogString := debugLogString . " #(" . countOfSkips . ")@(" . currTime . ")"      
        
        MouseMove, 10, 10, , R                                       ; Move mouse 10 pixels down & 10 pixels to right ..then move it back
        Sleep, 100
        MouseMove, -10, -10, , R
        
        SendInput, {Ctrl Down}{Tab}{Ctrl Up}                         ; Press CTRL+TAB ... then CTRL+SHIFT+TAB
        sleep, 100
        SendInput, {Ctrl Down}{Shift Down}{Tab}{Shift Up}{Ctrl Up} 
    }
     else {
        prevX := currX
        prevY := currY
        countOfSkips = 0
     }
     
    if( countOfSkips >= KeepAwakeIterations) {                      ; If screen saver has been avoided KeepAwakeIterations times, then exit the script
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

SHOWCONFIG:
  Run, %A_ScriptDir%/ScreenSaverSaver.ini
return

SHOWLOGS:
  MsgBox, 0,, % debugLogString
return
   
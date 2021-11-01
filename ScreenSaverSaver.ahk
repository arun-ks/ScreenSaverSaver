#SingleInstance force
#NoEnv

Menu, Tray, Icon, %A_ScriptDir%/resources/ScreenSaverSaver.ico, , 0

IniRead,KeepAwakeMinutes   ,%A_ScriptDir%/ScreenSaverSaver.ini,Settings,KeepAwakeMinutes     ; Duration after which mouse should move. Make it lesser than system defined screensaver actication time.
IniRead,KeepAwakeIterations,%A_ScriptDir%/ScreenSaverSaver.ini,Settings,KeepAwakeIterations     ; 

CoordMode, Mouse, Screen
MouseGetPos, prevX, prevY   
countOfSkips = 0

Loop {
    Sleep, % KeepAwakeMinutes * 60 * 1000      ; Time in milli seconds. Screensaver now starts at 15 minutes, so use 12 minutes (720000 ms) here 
   
    MouseGetPos, currX, currY   
    If (currX = prevX and currY = prevY) {
        MouseMove, 10, 10, , R
        Sleep, 100
        MouseMove, -10, -10, , R
        countOfSkips := countOfSkips + 1
     }
     else {
              prevX := currX
              prevY := currY
              countOfSkips = 0
     }
     
     if( countOfSkips >= KeepAwakeIterations) {
          FormatTime, currTime, Time, ddd MMMM d, hh:mm:ss 
           MsgBox % "Stopping ScreenSaver Saver after " . KeepAwakeIterations . " consecutive iterations at " . currTime
           break
      }
}


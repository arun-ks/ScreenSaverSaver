#SingleInstance force
#NoEnv

; Avoid Screen Saver from starting by slightly moving mouse every few minutes.


Menu, Tray, Icon, %A_ScriptDir%/resources/ScreenSaverSaver.ico, , 0

IniRead,KeepAwakeMinutes   ,%A_ScriptDir%/ScreenSaverSaver.ini,Settings,KeepAwakeMinutes       ; Duration after which mouse should move. Make it lesser than system defined screensaver actication time.
IniRead,KeepAwakeIterations,%A_ScriptDir%/ScreenSaverSaver.ini,Settings,KeepAwakeIterations     ; 
global ShowDebugMesgFlag
IniRead,ShowDebugMesgFlag,  %A_ScriptDir%/ScreenSaverSaver.ini,Settings,ShowDebugMesgFlag   ; 

VanishingDebugMesg("Starting app with params KeepAwakeMinutes=" . KeepAwakeMinutes . ", KeepAwakeIteration=" . KeepAwakeIterations . ", and ShowDebugMesgFlag=" . ShowDebugMesgFlag , 	  4)  ;

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
	while seconds2Sleep > 0
  {
  	  	Gui, Add, Text, x0 y0, %text%  ;the text to display
	    Gui, Show, NoActivate, Xn: 0, Yn: 0
        seconds2Sleep := seconds2Sleep - 1
      Sleep, 1000
  }
  

	Gui, Destroy
}
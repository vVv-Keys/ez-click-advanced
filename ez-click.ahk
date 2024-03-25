; Set the default click interval in milliseconds
ClickInterval := 1000

; Set the default click location (center of the screen)
ClickX := A_ScreenWidth / 2
ClickY := A_ScreenHeight / 2

; Initialize the variable to track if clicking is active
Clicking := false
Paused := false

; Define custom click patterns
CustomClickPatterns := {
    "Double Click": ["Single Click", "Single Click"],
    "Triple Click": ["Single Click", "Single Click", "Single Click"]
}

; Hotkey to start/stop clicking (F1 to toggle, F3 to pause/resume)
F1::
    ToggleClicking()
return

F3::
    TogglePause()
return

; Hotkey to set custom click location (F2)
F2::
    MouseGetPos, ClickX, ClickY
    MsgBox, Click location set to X:%ClickX%, Y:%ClickY%
return

; Click loop function
ClickLoop:
    if (Paused)
        return
    
    ExecuteClickPattern("Double Click") ; Execute a specific click pattern (change as needed)
    Random, RandomInterval, 750, 1250 ; Randomize click interval between 0.75s and 1.25s
    SetTimer, ClickLoop, %RandomInterval%
return

; Execute a custom click pattern
ExecuteClickPatt

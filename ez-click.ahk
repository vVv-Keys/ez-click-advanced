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
F1::ToggleClicking()
F3::TogglePause()

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
ExecuteClickPattern(patternName) {
    pattern := CustomClickPatterns[patternName]
    if (pattern) {
        for each, action in pattern
            SingleClick()
    }
}

SingleClick() {
    SmoothMouseMove(ClickX, ClickY)
    Click, %ClickX%, %ClickY%
}

ToggleClicking() {
    Clicking := !Clicking
    if (Clicking) {
        if (!ConfirmClicking()) {
            Clicking := false
            return
        }
        SetTimer, ClickLoop, %ClickInterval%
        SetTimer, UpdateCursor, 100 ; Check every 100 milliseconds to update cursor
        MsgBox, Clicking started. Press F1 to stop or F3 to pause.
    } else {
        SetTimer, ClickLoop, Off
        SetTimer, UpdateCursor, Off
        ToolTip  ; Clear any existing tooltip
        MsgBox, Clicking stopped.
    }
}

TogglePause() {
    Paused := !Paused
    if (Paused) {
        SetTimer, UpdateCursor, Off
        ToolTip, Paused`nPress F3 to resume.
    } else {
        SetTimer, UpdateCursor, 100
        ToolTip, Clicking...`nPress F1 to stop.
    }
}

; Function to update cursor and display tooltip when clicking
UpdateCursor:
    if (Clicking && !Paused) {
        ToolTip, Clicking...`nPress F1 to stop.
        SetSystemCursor(32649) ; Change cursor to "hand" cursor
    } else if (Paused) {
        ToolTip, Paused`nPress F3 to resume.
    } else {
        ToolTip  ; Clear tooltip when not clicking
        SetSystemCursor(32512) ; Reset cursor to default
    }
return

; Function to change system cursor
SetSystemCursor(id) {
    h_cursor := DllCall("LoadCursor", "uint", 0, "uint", id)
    DllCall("SetSystemCursor", "uint", h_cursor, "uint", 32512)
}

; Function to smoothly move the mouse cursor to a target position
SmoothMouseMove(TargetX, TargetY, Duration := 200) {
    MouseGetPos, StartX, StartY
    Steps := Duration / 10
    StepX := (TargetX - StartX) / Steps
    StepY := (TargetY - StartY) / Steps
    SleepInterval := Duration / Steps
    
    Loop, % Steps {
        NewX := StartX + StepX * A_Index
        NewY := StartY + StepY * A_Index
        DllCall("mouse_event", uint, 1, int, NewX-StartX, int, NewY-StartY, uint, 0, int, 0) ; MOUSEEVENTF_MOVE
        Sleep, SleepInterval
    }
    DllCall("mouse_event", uint, 1, int, TargetX-StartX, int, TargetY-StartY, uint, 0, int, 0) ; MOUSEEVENTF_MOVE
}

; Error Handling: Check if mouse position is valid
CheckMousePosition() {
    MouseGetPos, MouseX, MouseY
    if (MouseX < 0 || MouseY < 0 || MouseX > A_ScreenWidth || MouseY > A_ScreenHeight) {
        MsgBox, Invalid mouse position detected. Please reset the position using F2.
        return false
    }
    return true
}

; Logging: Log actions performed by the script
LogAction(action) {
    FormatTime, CurrentDateTime,, yyyy-MM-dd HH:mm:ss
    FileAppend, %CurrentDateTime% - %action%`n, script_log.txt
}

; Configurability: Load user settings from configuration file
LoadConfig() {
    ; Example: Load settings from a configuration file
    ; Implement loading logic here
}

; Configurability: Save user settings to configuration file
SaveConfig() {
    ; Example: Save settings to a configuration file
    ; Implement saving logic here
}

; Safety Features: Confirmation dialog before starting clicking
ConfirmClicking() {
    MsgBox, 4, Confirmation, Are you sure you want to start clicking?
    return (MsgBoxResult = "Yes")
}

; Compatibility: Ensure compatibility with different screen resolutions and DPI settings
CheckCompatibility() {
    ; Check and handle compatibility issues here
}

; Call additional functions
CheckMousePosition()
LoadConfig()
CheckCompatibility()

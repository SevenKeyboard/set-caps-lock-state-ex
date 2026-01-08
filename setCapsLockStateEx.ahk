#Requires AutoHotkey v1.1.31+
;==============================================================
; setCapsLockStateEx — Sets CapsLock state with optional current-state checks and Always modes
;
; GitHub: https://github.com/SevenKeyboard/set-caps-lock-state-ex
; Author: SevenKeyboard Ltd. (2026)
; License: The Unlicense
;==============================================================
class VersionManager_setCapsLockStateEx
{
    static _ := VersionManager_setCapsLockStateEx._init()
    _init()    {
        global
        SETCAPSLOCKSTATEEX_VERSION := "1.1.0"
    }
}
setCapsLockStateEx(onOff := "", checkCurrentState := false)    {
    static isCapsLockAlways := false
    bRet := false
    prevSCS := A_StringCaseSense
    stringCaseSense Off
    switch (onOff)
    {
        case "":
            isCapsLockAlways := false
            setCapsLockState
        case "On", true:
            if (checkCurrentState && !isCapsLockAlways && getKeyState("CapsLock", "T"))
                goto Cleanup_C378C829
            isCapsLockAlways := false
            setCapsLockState On
        case "Off", false:
            if (checkCurrentState && !isCapsLockAlways && !getKeyState("CapsLock", "T"))
                goto Cleanup_C378C829
            isCapsLockAlways := false
            setCapsLockState Off
        case "Toggle", -1:
            isCapsLockAlways := false
            setCapsLockState % (!getKeyState("CapsLock", "T"))
        ;---------------------------------
        case "Always", "A":
            isCapsLockAlways := true
            setCapsLockState % "Always" (getKeyState("CapsLock", "T") ? "On" : "Off")
        case "AlwaysOn", "1A":
            if (checkCurrentState && isCapsLockAlways && getKeyState("CapsLock", "T"))
                goto Cleanup_C378C829
            isCapsLockAlways := true
            setCapsLockState AlwaysOn
        case "AlwaysOff", "0A":
            if (checkCurrentState && isCapsLockAlways && !getKeyState("CapsLock", "T"))
                goto Cleanup_C378C829
            isCapsLockAlways := true
            setCapsLockState AlwaysOff
        case "AlwaysToggle", "-1A":
            isCapsLockAlways := true
            setCapsLockState % "Always" (getKeyState("CapsLock", "T") ? "Off" : "On")
        ;---------------------------------
        case "IsAlways":
            bRet := isCapsLockAlways
            goto Cleanup_C378C829
    }
    bRet := true
Cleanup_C378C829:
    stringCaseSense % prevSCS
    return bRet
}
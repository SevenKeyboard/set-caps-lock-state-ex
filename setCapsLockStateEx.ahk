#Requires AutoHotkey v2.0.0+
;==============================================================
; setCapsLockStateEx — Sets CapsLock state with optional current-state checks and Always modes
;
; GitHub: https://github.com/SevenKeyboard/set-caps-lock-state-ex
; Author: SevenKeyboard Ltd. (2026)
; License: The Unlicense
;
; Documentation / References:
;   Re: [V2] Overwrite ahk functions???
;     https://www.autohotkey.com/boards/viewtopic.php?t=123630#p549610
;==============================================================
class VersionManager_setCapsLockStateEx
{
    static _ := this._init()
    static _init()    {
        global
        SETCAPSLOCKSTATEEX_VERSION := "1.1.0"
    }
}
setCapsLockStateEx(onOff := "", checkCurrentState := false)    {
    isCapsLockAlways := SetCapsLockStateHook_E246BEBF.IsCapsLockAlways
    switch (onOff), false
    {
        case "":
            setCapsLockState()
        case "On", true:
            if (checkCurrentState && !isCapsLockAlways && getKeyState("CapsLock", "T"))
                return false
            setCapsLockState(true)
        case "Off", false:
            if (checkCurrentState && !isCapsLockAlways && !getKeyState("CapsLock", "T"))
                return false
            setCapsLockState(false)
        case "Toggle", -1:
            setCapsLockState(!getKeyState("CapsLock", "T"))
        ;---------------------------------
        case "Always", "A":
            setCapsLockState("Always" (getKeyState("CapsLock", "T") ? "On" : "Off"))
        case "AlwaysOn", "1A":
            if (checkCurrentState && isCapsLockAlways && getKeyState("CapsLock", "T"))
                return false
            setCapsLockState("AlwaysOn")
        case "AlwaysOff", "0A":
            if (checkCurrentState && isCapsLockAlways && !getKeyState("CapsLock", "T"))
                return false
            setCapsLockState("AlwaysOff")
        case "AlwaysToggle", "-1A":
            setCapsLockState("Always" (getKeyState("CapsLock", "T") ? "Off" : "On"))
        ;---------------------------------
        case "IsAlways":
            return isCapsLockAlways
    }
    return true
}
class SetCapsLockStateHook_E246BEBF
{
    static _ := this._init()
    static _init()    {
        this._isCapsLockAlways := false
        setCapsLockState.defineProp("call", {call:this._setCapsLockState})
    }
    static _setCapsLockState(state?)    {
        if !(this is func)
            return
        fn := this ;  setCapsLockState
        this := SetCapsLockStateHook_E246BEBF
        if (!isSet(state))    {
            this._isCapsLockAlways := false
        }  else  {
            if (state == true || state == false || state ~= "iD)^(|On|Off)$")
                this._isCapsLockAlways := false
            else if (state ~= "iD)^Always(On|Off)$")
                this._isCapsLockAlways := true
        }
        return (func.Prototype.call)(fn, state?)
    }
    static IsCapsLockAlways    {
        get => this._isCapsLockAlways
    }
}
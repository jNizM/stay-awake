; ===========================================================================================================================================================================

/*
	Stay Awake (written in AutoHotkey)

	Author ....: jNizM
	Released ..: 2021-10-21
	Modified ..: 2021-10-21
	License ...: MIT
	GitHub ....: https://github.com/jNizM/stay-awake
	Forum .....: https://www.autohotkey.com/boards/viewtopic.php?t=95857
*/


; SCRIPT DIRECTIVES =========================================================================================================================================================

#Requires AutoHotkey v2.0-

#SingleInstance
Persistent


; GLOBALS ===================================================================================================================================================================

app := Map("name", "Stay Awake", "version", "0.1", "release", "2021-10-21", "author", "jNizM", "licence", "MIT")

hFBFBFB := DllCall("gdi32\CreateBitmap", "int", 1, "int", 1, "uint", 0x1, "uint", 32, "int64*", 0xfbfbfb, "ptr")
hHLINE  := DllCall("gdi32\CreateBitmap", "int", 1, "int", 2, "uint", 0x1, "uint", 32, "int64*", 0x7fa5a5a57f5a5a5a, "ptr")


; TRAY ======================================================================================================================================================================

if (VerCompare(A_OSVersion, "10.0.22000") >= 0)
	TraySetIcon("shell32.dll", 26)

TrayMain := A_TrayMenu
TrayMain.Delete()
TrayMode := Menu()
TrayMode.Add("Off (Passive)", SetPassive)
TrayMode.Add("Keep awake indefinitely", SetIndefinitely)
TrayTemp := Menu()
TrayTemp.Add("30 minutes", SetTemporarily)
TrayTemp.Add("1 hour",     SetTemporarily)
TrayTemp.Add("2 hours",    SetTemporarily)
TrayMode.Add("Keep awake temporarily", TrayTemp)
TrayMain.Add("Mode", TrayMode)
TrayMain.Add("Keep Screen On", SetDisplayOn)
TrayMain.Add()
TrayMain.Add("Open Gui", Gui_Show)
;TrayMain.Add(Chr(0x221E), GetTimeLeft)
;TrayMain.Disable(Chr(0x221E))
;TrayMain.Add()
TrayMain.Add("Exit", ExitFunc)


; GUI =======================================================================================================================================================================

Main := Gui(, app["name"])
Main.MarginX := 15
Main.MarginY := 15

Main.SetFont("s20 w600", "Segoe UI")
Main.AddText("xm ym w300 0x200", app["name"])

Main.SetFont("s10 w400", "Segoe UI")
Main.AddGroupBox("xm ym+45 w352 h61 Section")
Main.AddPicture("xs+1 ys+9 w350 h50 BackgroundTrans", "HBITMAP:*" hFBFBFB)
Main.AddText("xs+15 ys+23 w245 h20 0x200 BackgroundFBFBFB", "Enable Awake")
CB01 := Main.AddCheckBox("x+1 yp w75 h20 0x220 BackgroundFBFBFB", "Off ")
CB01.OnEvent("Click", EventCall)

Main.SetFont("s10 w600", "Segoe UI")
Main.AddText("xm ym+130", "Behavior")

Main.SetFont("s10 w400", "Segoe UI")
Main.AddGroupBox("xm ym+145 w352 h61 Section")
Main.AddPicture("xs+1 ys+9 w350 h50 BackgroundTrans", "HBITMAP:*" hFBFBFB)
TX01 := Main.AddText("xs+15 ys+23 w245 h20 0x200 BackgroundFBFBFB Disabled", "Keep screen on")
CB02 := Main.AddCheckBox("x+1 yp w75 h20 0x220 BackgroundFBFBFB Disabled", "Off ")
CB02.OnEvent("Click", EventCall)

Main.SetFont("s10", "Segoe UI")
Main.AddGroupBox("xm ym+200 w352 h262 Section")
Main.AddPicture("xs+1 ys+9 w350 h251 BackgroundTrans", "HBITMAP:*" hFBFBFB)
TX02 := Main.AddText("xs+15 ys+18 w300 h20 0x200 BackgroundFBFBFB Disabled", "Mode")

Main.SetFont("s8 c777777", "Segoe UI")
Main.AddText("xs+15 y+0 w300 0x200 BackgroundFBFBFB", "Set the preferred behaviour or Awake")
Main.SetFont("s10 cDefault norm", "Segoe UI")

Main.AddPicture("xs+5 y+9 w341 h1 BackgroundTrans", "HBITMAP:*" hHLINE)

RB01 := Main.AddRadio("xs+20 ys+70 w25 h20 BackgroundFBFBFB Checked Disabled")
RB01.OnEvent("Click", EventCall)
RB02 := Main.AddRadio("xs+20 y+25 w25 h20 BackgroundFBFBFB Disabled")
RB02.OnEvent("Click", EventCall)
RB03 := Main.AddRadio("xs+20 y+25 w25 h20 BackgroundFBFBFB Disabled")
RB03.OnEvent("Click", EventCall)

Main.SetFont("s10", "Segoe UI")
TX03 := Main.AddText("xs+45 ys+70 w280 h20 0x200 BackgroundFBFBFB Disabled", "Inactive")
Main.SetFont("s8 c777777", "Segoe UI")
Main.AddText("xs+45 y+0 w280 h13 0x200 BackgroundFBFBFB", "Your PC operates according to its current power plan")
Main.SetFont("s10 cDefault norm", "Segoe UI")

TX04 := Main.AddText("xs+45 y+12 w280 h20 0x200 BackgroundFBFBFB Disabled", "Keep awake indefinitely")
Main.SetFont("s8 c777777", "Segoe UI")
Main.AddText("xs+45 y+0 w280 h13 0x200 BackgroundFBFBFB", "Keeps your PC awake until the setting is disabled")
Main.SetFont("s10 cDefault norm", "Segoe UI")

TX05 := Main.AddText("xs+45 y+12 w280 h20 0x200 BackgroundFBFBFB Disabled", "Keep awake temporarily")
Main.SetFont("s8 c777777", "Segoe UI")
Main.AddText("xs+45 y+0 w280 h13 0x200 BackgroundFBFBFB", "Keeps your PC awake until the set time elapses")
Main.SetFont("s10 cDefault norm", "Segoe UI")

TX06 := Main.AddText("xs+45 y+8 w80 h20 0x200 BackgroundFBFBFB Disabled", "Hours")
TX07 := Main.AddText("x+5 yp w80 h20 0x200 BackgroundFBFBFB Disabled", "Minutes")
ED01 := Main.AddEdit("xs+45 y+5 w80 Limit4 0x2000 Disabled")
Main.AddUpDown("Range0-1192", 1)
ED01.OnEvent("Change", EventCall)
ED02 := Main.AddEdit("x+5 yp w80 Limit5 0x2000 Disabled")
Main.AddUpDown("Range0-71568", 0)
ED02.OnEvent("Change", EventCall)

Main.OnEvent("Close", Gui_Hide)


; WINDOW EVENTS =============================================================================================================================================================

Gui_Show(*)
{
	Main.Show()
}


Gui_Hide(*)
{
	Main.Hide()
}


ExitFunc(*)
{
	if (hFBFBFB)
		DllCall("gdi32\DeleteObject", "ptr", hFBFBFB)
	if (hHLINE)
		DllCall("gdi32\DeleteObject", "ptr", hFBFBFB)
	Main.Destroy()
	StayAwake.Stop()
	ExitApp
}


EventCall(*)
{
	StayAwake.Stop()
	if (RB03.Value)
	{
		TX07.Opt("-Disabled")
		TX06.Opt("-Disabled")
		ED01.Opt("-Disabled")
		ED02.Opt("-Disabled")
		TrayMode.UnCheck("Off (Passive)")
		TrayMode.UnCheck("Keep awake indefinitely")
		TrayMode.Check("Keep awake temporarily")
		StayAwake.Period := 1000 * ((ED01.Value * 3600) + (ED02.Value * 60))
	}
	else
	{
		TX07.Opt("+Disabled")
		TX06.Opt("+Disabled")
		ED01.Opt("+Disabled")
		ED02.Opt("+Disabled")
		TrayMode.UnCheck("Keep awake temporarily")
	}


	if (RB02.Value)
	{
		TrayMode.UnCheck("Off (Passive)")
		TrayMode.Check("Keep awake indefinitely")
		TrayMode.UnCheck("Keep awake temporarily")
		StayAwake.Period := 0
	}
	else
	{
		TrayMode.Uncheck("Keep awake indefinitely")
	}


	if (RB01.Value)
	{
		TrayMode.Check("Off (Passive)")
		TrayMode.UnCheck("Keep awake indefinitely")
		TrayMode.UnCheck("Keep awake temporarily")
		StayAwake.Period := -1
	}
	else
	{
		TrayMode.UnCheck("Off (Passive)")
	}


	if (CB02.Value)
	{
		CB02.Text := "On "
		TrayMain.Check("Keep Screen On")
		StayAwake.Flags := "DisplayOn"
	}
	else
	{
		CB02.Text := "Off "
		TrayMain.UnCheck("Keep Screen On")
		StayAwake.Flags := ""
	}


	if (CB01.Value)
	{
		CB01.Text := "On "
		TX05.Opt("-Disabled")
		TX04.Opt("-Disabled")
		TX03.Opt("-Disabled")
		TX02.Opt("-Disabled")
		TX01.Opt("-Disabled")
		RB03.Opt("-Disabled")
		RB02.Opt("-Disabled")
		RB01.Opt("-Disabled")
		CB02.Opt("-Disabled")
		StayAwake.Start()
	}
	else
	{
		CB01.Text := "Off "
		TX07.Opt("+Disabled")
		TX06.Opt("+Disabled")
		TX05.Opt("+Disabled")
		TX04.Opt("+Disabled")
		TX03.Opt("+Disabled")
		TX02.Opt("+Disabled")
		TX01.Opt("+Disabled")
		ED01.Opt("+Disabled")
		ED02.Opt("+Disabled")
		RB03.Opt("+Disabled")
		RB02.Opt("+Disabled")
		RB01.Opt("+Disabled")
		CB02.Opt("+Disabled")
		TrayMode.UnCheck("Off (Passive)")
		TrayMode.UnCheck("Keep awake indefinitely")
		TrayMode.UnCheck("Keep awake temporarily")
		StayAwake.Stop()
	}
}


; FUNCTIONS =================================================================================================================================================================

SetPassive(ItemName, ItemPos, *)
{
	TrayMode.ToggleCheck(ItemName)

	if (MenuCheckState(TrayMode.Handle, ItemPos))
	{
		CB01.Value := 1
		RB01.Value := 1
		RB02.Value := 0
		RB03.Value := 0
		/*
		StayAwake.Stop()
		StayAwake.Period := -1
		StayAwake.Start()
		*/
	}
	else
	{
		RB01.Value := 0
	}
	EventCall()
}


SetIndefinitely(ItemName, ItemPos, *)
{
	TrayMode.Uncheck("Keep awake temporarily")
	TrayMode.ToggleCheck(ItemName)

	if (MenuCheckState(TrayMode.Handle, ItemPos))
	{
		CB01.Value := 1
		RB01.Value := 0
		RB02.Value := 1
		RB03.Value := 0
		/*
		StayAwake.Stop()
		StayAwake.Period := 0
		StayAwake.Start()
		*/
	}
	else
	{
		RB02.Value := 0
	}
	EventCall()
}


SetTemporarily(ItemName, ItemPos, *)
{
	TrayMode.Uncheck("Keep awake indefinitely")
	TrayMode.ToggleCheck("Keep awake temporarily")
	ModePos := ItemPos - ((ItemName = "30 minutes") ? 1 : (ItemName = "1 hour") ? 2 : 3)

	if (MenuCheckState(TrayMode.Handle, ModePos))
	{
		CB01.Value := 1
		RB01.Value := 0
		RB02.Value := 0
		RB03.Value := 1
		;StayAwake.Stop()
		if (ItemName = "30 minutes")
		{
			ED01.Value := 0
			ED02.Value := 30
			;StayAwake.Period := 1000 * 60 * 30
		}
		if (ItemName = "1 hour")
		{
			ED01.Value := 1
			ED02.Value := 0
			;StayAwake.Period := 1000 * 60 * 60
		}
		if (ItemName = "2 hours")
		{
			ED01.Value := 2
			ED02.Value := 0
			;StayAwake.Period := 1000 * 60 * 120
		}
		;StayAwake.Start()
	}
	else
	{
		RB03.Value := 0
	}
	EventCall()
}


SetDisplayOn(ItemName, ItemPos, *)
{
	TrayMain.ToggleCheck(ItemName)

	if (MenuCheckState(TrayMain.Handle, ItemPos))
	{
		CB02.Value := 1
		;StayAwake.Flags  := "DisplayOn"
	}
	else
	{
		CB02.Value := 0
		;StayAwake.Flags  := ""
	}
	EventCall()
}


MenuCheckState(Handle, Item)
{
	static MF_BYPOSITION := 0x00000400
	static MF_CHECKED    := 0x00000008

	MenuState := DllCall("user32\GetMenuState", "Ptr", Handle, "UInt", Item - 1, "UInt", MF_BYPOSITION, "UInt")
	if (MenuState = -1)
		return -1
	return !!(MenuState & MF_CHECKED)
}


; CLASS =====================================================================================================================================================================

class StayAwake
{
	static Timer  := 0
	static Period := 0
	static Flags  := ""


	Flags[Flags]
	{
		set => Flags
	}


	Period[Period]
	{
		set => Period
	}


	;static TimeLeft() => (this.StartTime + this.Period) - A_TickCount


	static Start()
	{
		this.Timer := Timer := this.RunLoop.bind(this)
		SetTimer Timer, 5000

		if (this.Period > 0)
		{
			this.RunOnce := RunOnce := this.Stop.bind(this)
			this.StartTime := A_TickCount
			SetTimer RunOnce, - this.Period
		}
	}


	static Stop()
	{
		this.SetState(this.EXECUTION_STATE.CONTINUOUS)
		if (Timer := this.Timer)
			SetTimer Timer, 0
	}


	static RunLoop()
	{
		switch this.Flags
		{
			case "DisplayOn":
				this.SetState(this.EXECUTION_STATE.CONTINUOUS | this.EXECUTION_STATE.SYSTEM_REQUIRED | this.EXECUTION_STATE.DISPLAY_REQUIRED)
				;MsgBox "DisplayOn"
			case "AwayMode":
				this.SetState(this.EXECUTION_STATE.CONTINUOUS | this.EXECUTION_STATE.SYSTEM_REQUIRED | this.EXECUTION_STATE.AWAYMODE_REQUIRED)
				;MsgBox "AwayMode"
			default:
				this.SetState(this.EXECUTION_STATE.CONTINUOUS | this.EXECUTION_STATE.SYSTEM_REQUIRED)
				;MsgBox "default"
		}
	}


	static SetState(State)
	{
		try
		{
			if (EXECUTION_STATE := DllCall("kernel32\SetThreadExecutionState", "UInt", State) != 0)
				return EXECUTION_STATE
		}
		catch
		{
			throw Error("SetThreadExecutionState failed", -1)
		}
	}


	class EXECUTION_STATE
	{
		static AWAYMODE_REQUIRED := 0x00000040
		static CONTINUOUS        := 0x80000000
		static DISPLAY_REQUIRED  := 0x00000002
		static SYSTEM_REQUIRED   := 0x00000001
	}
}


; ===========================================================================================================================================================================

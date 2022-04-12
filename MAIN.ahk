; Created by 		Cristófano Varacolaci
; For 			 	ObsessedDesigns Studios™, Inc.
; Version 			1.0.0.3
; Build             10:30 2022.04.10
;
;---- [changes]
;		
;	Version 	1.0.0.3
;	Build		11:00 2022.04.12
;	Added		Option to show or hide extension on menu links 
;				[show_file_ext = ini_SEXT]
;#####################################################################################
; INCLUDES
;#####################################################################################
#Include, inc\init.ahk

; creates the tray menu
Gosub, MENU

MAIN:
GoSub, CreateMenu
WatchFolder(ini_ROOT, "Update", SubTree := True, Watch := 0x03)
Return

XButton2::
#z::
	gosub, ShowMenu
return

Update(Folder, Changes) {
	GoSub CreateMenu
}

CreateMenu:
	Menu, %ini_ROOT%, add, Open %ini_ROOT%, OpenFolder
	ExtractIcon(ini_ROOT, "Open " . ini_ROOT)
	
	Loop, %ini_ROOT%\*.*, 2, 1 ; Folders only
	{
		if A_LoopFileAttrib contains H,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
		continue  ; Skip this file and move on to the next one.
		StringGetPos, pos, A_LoopFileLongPath, \, R
		if (pos <> -1) ; it has a parent
			StringLeft, ParentFolderDirectory, A_LoopFileLongPath, %pos%
		if (pos = -1) ; it has no parent 
			ParentFolderDirectory := ini_ROOT
		Menu, %A_LoopFileLongPath%, add, Open %A_LoopFileName%, OpenFolder
		ExtractIcon(A_LoopFileLongPath, "Open " . A_LoopFileName)
		Menu, % ParentFolderDirectory, add, %A_LoopFileName%, :%A_LoopFileLongPath%
		ExtractIcon(ParentFolderDirectory, A_LoopFileName)
	}
		

	Loop, %ini_ROOT%\*.*, 0, 1 ; Files only
	{
		;msgbox % A_LoopFileLongPath
		if A_LoopFileAttrib contains H,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
		continue  ; Skip this file and move on to the next one.
		StringGetPos, pos, A_LoopFileLongPath, \, R
		if (pos <> -1) ; it has a parent
			StringLeft, ParentFolderDirectory, A_LoopFileLongPath, %pos%
		if (pos = -1) ; it has no parent 
			ParentFolderDirectory := ini_ROOT

		SplitPath, A_LoopFileName, full_file_name,, file_ext, file_name
		
		if (ini_SEXT = "true")
			file_name := file_name . "." . file_ext

		Menu, %ParentFolderDirectory%, add, %file_name%, OpenFile
		ExtractIcon(ParentFolderDirectory, file_name)
	}
Return

OpenFile:
	run %A_ThisMenu%\%A_ThisMenuItem%
return

OpenFolder:
	run %A_ThisMenu%
return

ShowMenu:
	Menu, %ini_ROOT%, Show
return


END:
GuiEscape:
GuiClose:
ExitApp
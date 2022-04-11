; Created by 		Cristófano Varacolaci
; For 			 	ObsessedDesigns Studios™, Inc.
; Version 			0.1.0.0
; Build 			16:30 2021.12.05
; ==================================================================================================================================
; Function:       variablesFromIni
; Description     read all variables in an ini and store in variables
; Usage:          variablesFromIni(_SourcePath, _VarPrefixDelim = "_")
; Parameters:
;  _SourcePath    	-  path to the ini file ["config/main.ini"]
;  _ValueDelim      -  This is the delimitator used for key 'delim' value function
;  _VarPrefixDelim 	-  This specifies the separator between section name and key name.
; 						All section names and key names are merged into single name.
; Return values:  
;     Variables from the ini, named after SECTION Delimiter KEY
; Change history:
;     1.1.00.00/2021.12.05
;     Added _ValueDelim
; Remarks:
; Change history:
;     1.1.00.00/2022.03.30
;     Added _ValueDelim
;     corrected an error, now it is working again
; Remarks:
variablesFromIni(_SourcePath, _ValueDelim = "=", _VarPrefixDelim = "_")
{
    Global
    if !FileExist(CONFIGURATION_FILE){
        MsgBox, 16, % "Error", % "The file " . CONFIGURATION_FILE . " does not esxist`n`nWe'll create one for you with default values.`nPlease edit it to match your desired options."
    } else {        
        Local FileContent, CurrentPrefix, CurrentVarName, CurrentVarContent, DelimPos
        FileRead, FileContent, %_SourcePath%
        If ErrorLevel = 0
        {
            Loop, Parse, FileContent, `n, `r%A_Tab%%A_Space%
            {
                If A_LoopField Is Not Space
                {
                    If (SubStr(A_LoopField, 1, 1) = "[")
                    {
                        StringTrimLeft, CurrentPrefix, A_LoopField, 1
                        StringTrimRight, CurrentPrefix, CurrentPrefix, 1
                    }
                    Else
                    {
                        ;MsgBox, , Title, % A_LoopField
                        DelimPos := InStr(A_LoopField, _ValueDelim)
                        StringLeft, CurrentVarName, A_LoopField, % DelimPos - 1
                        StringTrimLeft, CurrentVarContent, A_LoopField, %DelimPos%
                        %CurrentPrefix%%_VarPrefixDelim%%CurrentVarName% = %CurrentVarContent%
                    }
                    
                }
            }
        }
    }
}
; ==================================================================================================================================
; Function:       Ini_write
; Description     writes a value into an ini file
; Usage:          Ini_write(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
;  value          -  the value to write on
; Return values:  
;     True on success, fail otherwise
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     oresult -> operation result
Ini_write(inifile, section, key, value="", ifblank=false) {
	;ifblank means if the key doesn't exist
	Iniread, v,% inifile,% section,% key

	if ifblank && (v == "ERROR")
		IniWrite,% value,% inifile,% section,% key
   oresult := ErrorLevel ? False : True
	if !ifblank
		IniWrite,% value,% inifile,% section,% key
   oresult := ErrorLevel ? False : True
   Return oresult
}
; ==================================================================================================================================
; Function:       Ini_read
; Description     Reads a value from an ini file
; Usage:          Ini_read(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
; Return values:  
;     value of the searched key
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
Ini_read(inifile, section, key){
	Iniread, v, % inifile,% section,% key, %A_space%
	if v = %A_temp%
		v := ""
	return v
}
; ==================================================================================================================================
; Function:       Ini_delete
; Description     Deletes value in an ini file
; Usage:          Ini_delete(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
; Return values:  
;     True on success, fail otherwise
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     oresult -> operation result
Ini_delete(inifile, section, key){
	IniDelete, % inifile, % section, % key
   oresult := ErrorLevel ? False : True
   Return oresult
}
; ==================================================================================================================================
; Function:       Change_Icon
; Description     Set the icon to the tray depending if it's compiled or not
; Usage:          changeIcon(file)
; Parameters:
;  file           -  path to the icon file ["icons/icon.ico"]
; Return values:  
;     nothing
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     Nothing
Change_Icon(file){
	if A_IsCompiled or H_Compiled 		; H_Compiled is a user var created if compiled with ahk_h
		Menu, tray, icon, % A_AhkPath
	else
		Menu, tray, icon, % file
}

; ==================================================================================================================================
; Function:             ExtractIcon
; Description           Extracts the icon from a folder or file
; Usage:                ExtractIcon(MenuName, MenuItemName)
; Parameters:
;  MenuName             - name of the menu to asign the icon
;  MenuItemName         - Text of the menu 
; Return values:  
;     nothing
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     Nothing
ExtractIcon(MenuName, MenuItemName) {
	; Allocate memory for a SHFILEINFOW struct.
	VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)
	
	; Get the file's icon.
	if DllCall("shell32\SHGetFileInfoW", "wstr", A_LoopFileFullPath
		, "uint", 0, "ptr", &fileinfo, "uint", fisize, "uint", 0x100 | 0x000000001)
	{
		hicon := NumGet(fileinfo, 0, "ptr")
		; Set the menu item's icon.
		Menu %MenuName%, Icon, %MenuItemName%, HICON:%hicon%
		; Because we used ":" and not ":*", the icon will be automatically
		; freed when the program exits or if the menu or item is deleted.
	}
}
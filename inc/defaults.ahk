/*
**************************
PROGRAM VARIABLES GLOBALS
**************************
*/
/*
**************************
PROGRAM VARIABLES GLOBALS
**************************
*/
global PROGNAME 			:= "MAIN"
global VERSION 				:= "1.0.0.0"
global RELEASEDATE 			:= "April 10, 2022"
global AUTHOR 				:= "Cristófano Varacolaci"
global ODESIGNS 			:= "obsessedDesigns Studios™, Inc."
global AUTHOR_PAGE 			:= "http://obsesseddesigns.com"
global AUTHOR_MAIL 			:= "cristo@obsesseddesigns.com"

global DATA_FOLDER			:= "Data"
global CONFIGURATION_FILE	:= "pml.ini"

global H_Compiled := RegexMatch(Substr(A_AhkPath, Instr(A_AhkPath, "\", 0, 0)+1), "iU)^(MAIN).*(\.exe)$") && (!A_IsCompiled) ? 1 : 0
global mainIconPath := H_Compiled || A_IsCompiled ? A_AhkPath : "Data\icons\main.ico"

INI_VARIABLES:
    ;read ini file for VARIABLES
    variablesFromIni(CONFIGURATION_FILE)

    PROGNAME := SYSTEM_name
    PROGNAME := ((!PROGNAME) ? ("Popup Menu Launcher") : (SYSTEM_name))

    VERSION := SYSTEM_version
    VERSION := ((!VERSION) ? ("1.0.0.2") : (VERSION))

    ini_LANG := SYSTEM_lang
    ini_LANG := ((!ini_LANG) ? ("english") : (ini_LANG))

    ini_ROOT := OPTIONS_rootdir
    ini_ROOT := ((!ini_ROOT) ? ("C:\PML") : (ini_ROOT))

if !FileExist(CONFIGURATION_FILE) {
    FileCreateDir, % ini_ROOT
    FileAppend, % "[SYSTEM]`nname=" . PROGNAME . "`nversion=" . VERSION . "`nlang=" . ini_LANG . "`n`n[OPTIONS]`nrootdir=" . ini_ROOT, % CONFIGURATION_FILE
    RunWait, PML.ini, A_ScriptDir
    Goto, INI_VARIABLES
}

;---- [Initilization]
Change_Icon(mainIconPath)
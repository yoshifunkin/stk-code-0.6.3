;--------------------------------------------------------------------------
; To use just install NSIS 3.x and compile.
; Just be careful to select the good vcredist_86.exe here
; since the game can be compiled using VC9 or VC10
;(either rename the file here or in the dir).

;--------------------------------
; Include Modern UI 2

  !include "MUI2.nsh"

;--------------------------------
; General

  ;Name and file
  Name "SuperTuxKart 0.6.3 Alpha-4"
  OutFile "supertuxkart-0.6.3-alpha4-win.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\SuperTuxKart 0.6.3 Alpha-4"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\SuperTuxKart 0.6.3 Alpha-4" ""

  ;Sets the text in the bottom corner
  BrandingText "SuperTuxKart 0.6.3 Installer"

  ;Set the icon
  !define MUI_ICON "install.ico"
  !define MUI_UNICON "uninstall.ico"

  ;Sets the compressor to /SOLID lzma which when I tested was the best
  SetCompressor /SOLID lzma

  ;Vista redirects $SMPROGRAMS to all users without this
  RequestExecutionLevel admin

;--------------------------------
; Variables

  Var MUI_TEMP
  Var STARTMENU_FOLDER

;--------------------------------
; Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
; Pages

  ; Installer pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "..\..\LICENSE.md"
  !insertmacro MUI_PAGE_DIRECTORY

  ; Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\SuperTuxKart 0.6.3 Alpha-4"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER

  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  ; Uninstaller pages
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Installer Sections

Section "Main Section" SecMain

  SetOutPath "$INSTDIR"

  ; Adds all the supertuxkart files
  File /r "..\..\*.dll"
  File /r "..\..\supertuxkart.exe"
  File /r "..\..\TODO"
  File /r "..\..\README.md"
  File /r "icon.ico"
  File /r "install.ico"
  File /r "uninstall.ico"
  File /r "..\..\INSTALL.md"
  File /r "..\..\LICENSE.md"
  File /r "..\..\ChangeLog.md"
  File /r "..\..\data"
  
  SetOutPath $INSTDIR\doc
  
  File /r "..\..\doc\challenges_dependencies.odg"
  File /r "..\..\doc\conventions.txt"
  File /r "..\..\doc\implementation.txt"
  File /r "..\..\doc\robots.txt"
  
  SetOutPath $INSTDIR
  
  ; Store installation folder
  WriteRegStr HKCU "Software\SuperTuxKart 0.6.3 Alpha-4" "" $INSTDIR

  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    ; Create shortcuts
    CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\uninstall.ico"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\SuperTuxKart 0.6.3 Alpha-4.lnk" "$INSTDIR\supertuxkart.exe" "" "$INSTDIR\icon.ico"

  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

Section -Prerequisites
  ; Be careful to select the good vcredist_86.exe here
  ; since the game can be compiled using VC9 or VC10
  ; (either rename the file here or in the dir)
  SetOutPath $INSTDIR\prerequisites
  MessageBox MB_YESNO "Install Microsoft VC++ runtime libraries?" /SD IDYES IDNO endVC
    File "..\..\prerequisites\vcredist_x86.exe"
    ExecWait "$INSTDIR\Prerequisites\vcredist_x86.exe"
    Goto endVC
  endVC:
  MessageBox MB_YESNO "Install OpenAL sound libraries?" /SD IDYES IDNO endOA
    File "..\..\prerequisites\oalinst.exe"
    ExecWait "$INSTDIR\Prerequisites\oalinst.exe"
    Goto endOA
  endOA:
SectionEnd
;--------------------------------
; Uninstaller Section

Section "Uninstall"redist

  ; Removes all the supertuxkart data files
  RMDir /r /REBOOTOK $INSTDIR

  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"

  ; Remove start menu items
  !insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP

  Delete "$SMPROGRAMS\$MUI_TEMP\Uninstall.lnk"
  Delete "$SMPROGRAMS\$MUI_TEMP\SuperTuxKart 0.6.3 Alpha-4.lnk"

  ; Delete empty start menu parent diretories
  StrCpy $MUI_TEMP "$SMPROGRAMS\$MUI_TEMP"

  startMenuDeleteLoop:
	ClearErrors
    RMDir $MUI_TEMP
    GetFullPathName $MUI_TEMP "$MUI_TEMP\.."

    IfErrors startMenuDeleteLoopDone

    StrCmp $MUI_TEMP $SMPROGRAMS startMenuDeleteLoopDone startMenuDeleteLoop
  startMenuDeleteLoopDone:

  DeleteRegKey /ifempty HKCU "Software\SuperTuxKart 0.6.3 Alpha-4"

SectionEnd


; Installateur Inno Setup du client Nextcloud compilé nativement pour Windows ARM64.
; Compilé par .github/workflows/build.yml :
;   ISCC.exe /DAppVersion=35.0.3 /DSourceDir=C:\stage /DOutputDir=out nextcloud-arm64.iss

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef SourceDir
  #define SourceDir "..\stage"
#endif
#ifndef OutputDir
  #define OutputDir "..\out"
#endif

#define AppName      "Nextcloud"
#define AppVendor    "Nextcloud GmbH"
#define AppExe       "nextcloud.exe"
#define UriScheme    "nc"
#define ContextMenuGuid "{{BC6988AB-ACE2-4B81-84DC-DC34F9B24401}"

[Setup]
; Identifiant propre à ce build ARM64 (différent de l'installateur officiel)
AppId={{6F1C2A4E-8B3D-4E7A-9C21-5A0D3E9B7F42}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion} (ARM64)
AppPublisher={#AppName} ARM64 community build
AppPublisherURL=https://github.com/bertrandvallat/nextcloud-win-arm64
AppSupportURL=https://github.com/bertrandvallat/nextcloud-win-arm64/issues
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
MinVersion=10.0.22000
PrivilegesRequired=admin
OutputDir={#OutputDir}
OutputBaseFilename=Nextcloud-{#AppVersion}-arm64-setup
SetupIconFile={#SourceDir}\Nextcloud.ico
UninstallDisplayIcon={app}\{#AppExe}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=force
RestartApplications=no
ChangesAssociations=yes
LicenseFile={#SourceDir}\COPYING.txt

[Languages]
Name: "french";  MessagesFile: "compiler:Languages\French.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "autostart";   Description: "Lancer Nextcloud au démarrage de Windows"; GroupDescription: "Options :"
Name: "shellext";    Description: "Intégration à l'Explorateur (icônes d'état, menu contextuel)"; GroupDescription: "Options :"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Excludes: "NCContextMenu.dll,NCOverlays.dll,Nextcloud.ico,COPYING.txt"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#SourceDir}\COPYING.txt"; DestDir: "{app}"; Flags: ignoreversion
; Extensions de l'Explorateur : enregistrées via DllRegisterServer
Source: "{#SourceDir}\NCContextMenu.dll"; DestDir: "{app}\shellext"; Tasks: shellext; Flags: ignoreversion regserver restartreplace uninsrestartdelete
Source: "{#SourceDir}\NCOverlays.dll";    DestDir: "{app}\shellext"; Tasks: shellext; Flags: ignoreversion regserver restartreplace uninsrestartdelete

[Registry]
; Pas de mise à jour automatique : l'updater officiel installerait la version x64
Root: HKLM; Subkey: "Software\{#AppVendor}\{#AppName}"; ValueType: dword; ValueName: "skipUpdateCheck"; ValueData: 1; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\{#AppVendor}\{#AppName}"; ValueType: string; ValueName: ""; ValueData: "{app}"
; Gestionnaire d'URL nc:// (connexion depuis le navigateur, « ouvrir localement »)
Root: HKLM; Subkey: "Software\Classes\{#UriScheme}"; ValueType: string; ValueData: "URL:{#AppName} Protocol"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\{#UriScheme}"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKLM; Subkey: "Software\Classes\{#UriScheme}\DefaultIcon"; ValueType: string; ValueData: """{app}\{#AppExe}"""
Root: HKLM; Subkey: "Software\Classes\{#UriScheme}\shell\open\command"; ValueType: string; ValueData: """{app}\{#AppExe}"" ""%1"""
; Menu contextuel affiché aussi dans le menu compact de Windows 11
Root: HKLM; Subkey: "Software\Classes\CLSID\{#ContextMenuGuid}"; ValueType: string; ValueName: "ContextMenuOptIn"; ValueData: ""; Tasks: shellext
; Démarrage automatique
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#AppName}"; ValueData: """{app}\{#AppExe}"" --background"; Tasks: autostart; Flags: uninsdeletevalue

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}";  Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent runasoriginaluser

[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/F /IM {#AppExe}"; Flags: runhidden; RunOnceId: "KillNextcloud"

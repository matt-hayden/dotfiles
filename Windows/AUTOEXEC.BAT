@echo OFF
@rem Windows 2000/XP build environment

@rem Specific local customizations may exist in %HOSTNAME%.BAT, including file
@rem locations and local version workarounds.

@rem This script sets up a default environment based on some installation
@rem defaults. Wrap a command, for example in a shortcut like:
@rem console.bat bash --login -i
@rem Set SHELL to something like:
@rem "%ProgramFiles%\Git\bin\sh.exe" --login -i
@rem or get the default, pulled from MSYSCON, finally resorting to ComSpec.

@rem To run this in the nice Cygwin terminal emulator, create a shortcut like
@rem F:\cygwin\bin\mintty.exe -i /Cygwin-Terminal.ico -e cmd /C %HOME%\AUTOEXEC.BAT

@rem Beware that batch syntax is weird:
@rem		if /I "%PATH:Python=%" EQU "%PATH%"
@rem This matches if "%PATH%" with _Python_ substituted by nothing
@rem ("%PATH:Python=%") equals "%PATH%" -- in other words, Python is not in 
@rem %PATH%.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::ENVIRONMENT VARIABLES::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem Pay attention when setting the following:
@rem EDITOR
@rem GNUPGHOME
@rem HOME
@rem LANG
@rem MACROFILE
@rem PATH
@rem PATHEXT
@rem PYTHONINPECT
@rem PYTHONPATH
@rem SHELL
@rem TEMP
@rem VISUAL

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@SETLOCAL ENABLEEXTENSIONS
	set params=%*
	set WD=%CD%
	if defined SESSIONNAME (title Starting %SESSIONNAME%) else (title Starting %params%) 
	@rem set DEBUG (to something) here to see output
	@rem set DEBUG=15
	if defined DEBUG (
		if /I "%PROMPT:DEBUG=%" EQU "%PROMPT%" set PROMPT=$CDEBUG$F$S%PROMPT%
		echo ERRORLEVEL: %ERRORLEVEL%
	)
	@rem Note the use of the escape character ^ here:
	if not defined ProgramFiles^(x86^) (set ProgramFiles^(x86^)=%ProgramFiles%)
	
	set TMP=%TEMP%
	set TMPDIR=%TEMP%
	if not defined LOGNAME (set LOGNAME=%USERNAME%)
	if not defined USER (set USER=%USERNAME%)
	if not defined HOSTNAME (set HOSTNAME=%COMPUTERNAME%)
	
	@rem Customize here for different possible shells
	if defined SHELL (
		set mySHELL=%SHELL%
	) else if defined MSYSCON (
		set mySHELL=%MSYSCON%
	) else if exist "%WD%"\bin\busybox.exe (
		set mySHELL=%WD%\bin\busybox.exe bash --login -i
	) else if exist "%HOME%"\bin\busybox.exe (
		set mySHELL=%HOME%\bin\busybox.exe bash --login -i
	)

:DEFAULTS
@rem Note that quoting is different than shell (it is often not required). 
@rem For example, less handles quotes in options specially. Also, %% is a 
@rem literal % for DOS environment variables.
	if not defined MINGW32FGCOLOR (
		set MINGW32FGCOLOR=Navy
		set MSYSFGCOLOR=%MINGW32FGCOLOR%
		)
	if not defined MINGW32BGCOLOR (
		set MINGW32BGCOLOR=White
		set MSYSBGCOLOR=%MINGWBGCOLOR%
		)

rem Version control transmitters spawn these wrappers in different ways: some
rem will take the -batch option and others won't.
@rem (see notes on Cygwin rsync below)
	if not defined VERSION_CONTROL (set VERSION_CONTROL=numbered)
	rem gnu tar uses RSH, RSH_COMMAND to set the remote rsh filename
	if not defined RSH (set RSH=plink.exe -batch)
	if not defined BZR_SSH (set BZR_SSH=plink.exe)
	if not defined CVS_RSH (set CVS_RSH=%RSH%)
	if not defined GIT_SSH (set GIT_SSH=plink.exe)
	if not defined SVN_SSH (set SVN_SSH=%RSH%)

rem CVSIGNORE already contains *~ and *.bak
	if not defined CVSIGNORE (set CVSIGNORE=*.tmp ~$*)
	if not defined EDITOR (set EDITOR=notepad.exe)
	if not defined LANG (set LANG=C)

rem Note that the LESS option --quit-if-one-screen/-F doesn't work with 
rem TERM cygwin. LESS erases it's portion of the screen after quitting. 
rem Also, the --quit-on-intr option is absent in DOS.
	if not defined LESS (set LESS=-eiqswJMR --tabs=4 )
	if not defined PAGER (set PAGER=less)
	rem if not defined PLINK_PROTOCOL (set PLINK_PROTOCOL=ssh)
	if not defined VISUAL (set VISUAL=%EDITOR%)
	rem	if not defined XZ_DEFAULTS (set XZ_DEFAULTS=--memlimit=150MiB)

	if not defined CALENDAR_DIR if exist "%HOME%\.calendar" (
		set CALENDAR_DIR=%HOME%\.calendar
	)
	if not defined GNUPGHOME if exist "%HOME%\.gnupg" (
		set GNUPGHOME=%HOME%\.gnupg
	)
	if not defined PYTHONUSERBASE if exist "%HOME%\.local" (
		set PYTHONUSERBASE=%HOME%\.local
	)
:::::::::::::::::::::::::::::INSTALLATION PATHS::::::::::::::::::::::::::::
rem MSYS/MinGW seems to be provided by several different packages. Some 
rem default installation paths are here. You can override these with
rem the environment variable MINGW_ROOT and CYGWIN_ROOT.
	if not defined CYGWIN_ROOT (set CYGWIN_ROOT=%SystemDrive%\cygwin)
	if not defined MINGW_ROOT (set MINGW_ROOT=%SystemDrive%\MinGW)
@rem unwind is http://unwind.dk/, formerly known as wintools, 
@rem last released 2007-04-14 and development seems to have stopped.
	if not defined UNWIND_ROOT (set UNWIND_ROOT=%ProgramFiles(x86)%\unwind)
	
@rem Re-order here by preference
	if not exist "%MINGW_ROOT%" if exist "%ProgramFiles%\Git" (
		set MINGW_ROOT=%ProgramFiles%\Git
	) else if exist "%ProgramFiles(x86)%\Git" (
		set MINGW_ROOT=%ProgramFiles(x86)%\Git
	) else if exist "%ProgramFiles%\QGIS Chugiak" (
		set MINGW_ROOT=%ProgramFiles%\QGIS Chugiak\apps\msys
	) else if exist "%SystemDrive%\QtSDK\mingw" (
		set MINGW_ROOT=%SystemDrive%\QtSDK\mingw
	) else if exist "%SystemDrive%\Qt\2010.02\mingw" (
		set MINGW_ROOT=%SystemDrive%\Qt\2010.02\mingw
	)
	
	if not exist "%UNWIND_ROOT%" (
@rem set standard installation paths if installed seperately:
@rem GnuWin32 is http://gnuwin32.sourceforge.net/, last updated 27 December 2010.
@rem The GnuWin32 installer is http://sourceforge.net/projects/getgnuwin32/files/, last updated 2010-07-05
		if not defined GNUWIN32_ROOT (set GNUWIN32_ROOT=%ProgramFiles(x86)%\GnuWin32)
@rem SysInternals is http://technet.microsoft.com/en-us/sysinternals, last updated December 9, 2010
		if not defined SYSINTERNALS_ROOT (set SYSINTERNALS_ROOT=%ProgramFiles(x86)%\SysinternalsSuite)
@rem UnxUtils is http://unxutils.sourceforge.net/, last updated 14-04-03
		if not defined UNXUTILS_ROOT (set UNXUTILS_ROOT=%SystemDrive%\UnxUtils)
	)
	
:JAVA OPTIONS
@rem Java classpath is ; delimited
	if not defined CLASSPATH if exist "%WD%\java" (
		set CLASSPATH=%WD%\java
	) else if exist "%HOME%\java" (
		set CLASSPATH=%HOME%\java
	)
rem Search for Java, else assume ArcGIS or SPSS provide JRE
	if not defined JAVA_HOME (
		if exist "%ProgramFiles%\Java\jdk7" (
			set JAVA_HOME=%ProgramFiles%\Java\jdk7
		) else if exist "%ProgramFiles%\Java\jre7" (
			set JAVA_HOME=%ProgramFiles%\Java\jre7
		)
	)
	if not defined JAVA_HOME (
		if exist "%ProgramFiles%\Java\jdk6" (
			set JAVA_HOME=%ProgramFiles%\Java\jdk6
		) else if exist "%ProgramFiles%\Java\jre6" (
			set JAVA_HOME=%ProgramFiles%\Java\jre6
		) else if defined AGSDESKTOPJAVA (
			set JAVA_HOME="%AGSDESKTOPJAVA%\java\jre"
		) else if exist "%ProgramFiles%\IBM\SPSS\Statistics\20" (
			set JAVA_HOME=%ProgramFiles%\IBM\SPSS\Statistics\20\JRE
		)
	)
::::::::::::::::::::::::::::::::OBJECT PATHS::::::::::::::::::::::::::::::
	if exist "%WD%\bin" (
		set myPATH=%myPATH%;%WD%\bin
	) else if exist "%HOME%\bin" (
		set myPATH=%myPATH%;%HOME%\bin
	)
rem AHK scripts will look in this directory:
	if exist "%WD%\AutoHotKey" (
		set myPATH=%myPATH%;%WD%\AutoHotKey
	) else if exist "%HOME%\AutoHotKey" (
		set myPATH=%myPATH%;%HOME%\AutoHotKey
	)
	
:DOSKEY
	if not defined MACROFILE (set MACROFILE=%WD%\doskey.mac)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::BEGIN EXECUTABLE PARTS::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	if exist "%WD%\bin" set myPATH=%myPATH%;%WD%\bin

:PERL
	@rem Strawberry Perl seems to be hard-coded to C:\strawberry
		if exist "%SystemDrive%\Perl" (
			set myPATH=%myPATH%;%SystemDrive%\Perl\bin
		) else if exist "C:\strawberry" (
			set myPATH=%myPATH%;C:\strawberry\c\bin;C:\strawberry\perl\bin;C:\strawberry\perl\site\bin
		)
:PYTHON
	@rem Python path is ; seperated on Windows, : seperated on others
	if exist %WD%\python (
		set PYTHONPATH=%PYTHONPATH%;%WD%\python
	) else if exist %HOME%\python (
		set PYTHONPATH=%PYTHONPATH%;%HOME%\python
	)
	@rem Cygwin find doesn't like this:
	@rem if exist %APPDATA%\Python\Scripts (set PYTHONPATH=%PYTHONPATH%;%APPDATA%\Python\Scripts)
@rem Rearrange this section to your taste, or set a Python directory in
@rem your path. The stock CPython installer puts itself in PATH.
@rem Python 2.7 is required by SPSS 20, Python 2.6 is provided by ArcGIS, and 
@rem 2.5 is required by old versions of SPSS.
		if exist		"%SystemDrive%\Python27\python.exe" (
			set myPATH=%myPATH%;%SystemDrive%\Python27;%SystemDrive%\Python27\Scripts
		) else if exist	"%SystemDrive%\Python26\python.exe" (
			set myPATH=%myPATH%;%SystemDrive%\Python26;%SystemDrive%\Python26\Scripts
		) else if exist	"%SystemDrive%\Python25\python.exe" (
			set myPATH=%myPATH%;%SystemDrive%\Python25;%SystemDrive%\Python25\Scripts
@rem QGIS installs python 2.7
		) else if exist	"%ProgramFiles%\QGIS Chugiak\bin" (
			set myPATH=%myPATH%;%ProgramFiles%\QGIS Chugiak\bin;%ProgramFiles%\QGIS Chugiak\apps\Python27\Scripts
@rem ArcGIS 10 installs Python 2.6, somewhat weirdly 
		) else if exist	"%SystemDrive%\Python26\ArcGIS10.0\python.exe" (
			set myPATH=%myPATH%;%SystemDrive%\Python26\ArcGIS10.0;%SystemDrive%\Python26\ArcGIS10.0\Scripts
@rem Next, try OpenOffice, with a strange Scripts/ location
		) else if exist "%ProgramFiles%\LibreOffice 4\program\python.exe" (
			set myPATH=%myPATH%;%ProgramFiles%\LibreOffice 4\program
			if exist "%APPDATA%\LibreOffice\4\user" (
				myPATH=%myPATH%;%APPDATA%\LibreOffice\4\user\Scripts
				)
@rem Inkspace has a built-in python, but no Scripts/
		) else if exist "%ProgramFiles%\Inkscape\python" (
				set myPATH=%myPATH%;%ProgramFiles%\Inkscape\python
			)
:RUBY
		if exist "%SystemDrive%\Ruby193\bin" (
			set myPATH=%myPATH%;%SystemDrive%\Ruby193\bin
			)
		if exist "%HOME%\.gem\ruby" (
			set myPATH=%myPATH%;%HOME%\.gem\ruby\1.9\bin
			set myPATH=%myPATH%;%HOME%\.gem\ruby\1.8\bin
			)

:CYGWIN OPTIONS
rem Cygwin-linked programs will barf a message about pathname 
rem compatibility without this:
	set CYGWIN=nodosfilewarning %CYGWIN%
	
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::PATH:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@rem Locate32: http://locate32.net/content/view/18/31/
@rem If using Locate32 as your locate, it should go ahead of any other (UNIXy)
@rem locate(s)
	if exist "%ProgramFiles(x86)%\Locate" set myPATH=%myPATH%;%ProgramFiles(x86)%\Locate
::::::::::::::::::::::::::::::::::TOOLKITS::::::::::::::::::::::::::::::::
@rem Change the order of toolkits here to suit personal preference 
@rem (decreasing priority). The Unwind package installs some of these as a
@rem bundle.
	if exist "%SYSINTERNALS_ROOT%" set myPATH=%myPATH%;%SYSINTERNALS_ROOT%
rem Windows has it's own java.exe someplace, likely overriding your java
	if exist "%JAVA_HOME%" set myPATH=%JAVA_HOME%\bin;%myPATH%
	if exist "%MINGW_ROOT%" set myPATH=%myPATH%;%MINGW_ROOT%\bin
@rem MSYS is the hierarchy of user programs that are a companion to the
@rem MinGW build kit, but not necessarily in PATH.
	if exist "%SystemDrive%\MSYS" (
		set myPATH=%myPATH%;%SystemDrive%\MSYS\1.0\bin
	) else if exist "%MINGW_ROOT%\MSYS" (
		set myPATH=%myPATH%;%MINGW_ROOT%\MSYS
	)
@rem unwind installs gnuwin32
	if exist "%GNUWIN32_ROOT%" (set myPATH=%myPATH%;%GNUWIN32_ROOT%\bin;%GNUWIN32_ROOT%\sbin)
	if exist "%CYGWIN_ROOT%" (
		set myPATH=%myPATH%;%CYGWIN_ROOT%\bin;%CYGWIN_ROOT%\usr\sbin
	)
@rem unwind used to install unxutils?
	if exist "%UNXUTILS_ROOT%" (set myPATH=%myPATH%;%UNXUTILS_ROOT%\bin;%UNXUTILS_ROOT%\usr\local\wbin)
	if exist "%UNWIND_ROOT%" (
		set myPATH=%myPATH%;%UNWIND_ROOT%\bindutils;%UNWIND_ROOT%\getwin32\bin;%UNWIND_ROOT%\misctools;%UNWIND_ROOT%\putty
	)
	
:R OPTIONS
@rem Tune this for the latest version of R
@rem R version 2.12.1 required by SPSS 20
	if exist "%ProgramFiles%\R\R-2.12.1" (
		set myPATH=%myPATH%;%ProgramFiles%\R\R-2.12.1\bin
@rem R version 2.7.2 required by SPSS 17
	) else if exist "%ProgramFiles%\R\R-2.7.2" (
		set myPATH=%myPATH%;%ProgramFiles%\R\R-2.7.2\bin
	)

:MISC
rem Additional software useful on the command-line is assumed to be in
rem default installation directories.
	if exist "%ProgramFiles%\7-zip" set myPATH=%myPATH%;%ProgramFiles%\7-zip
	if /I "%PATH:Bazaar=%" EQU "%PATH%" if exist "%ProgramFiles%\Bazaar" set myPATH=%myPATH%;%ProgramFiles%\Bazaar
rem unwind installs CVSNT
	if /I "%PATH:CVS=%" EQU "%PATH%" if exist "%ProgramFiles(x86)%\CVSNT" set myPATH=%myPATH%;%ProgramFiles(x86)%\CVSNT
rem unwind might install GnuPG, but check for the latest official version
rem GnuPG 2 has two directories of executables
	if exist "%ProgramFiles(x86)%\GNU\GnuPG\gpg2.exe" set myPATH=%myPATH%;%ProgramFiles(x86)%\GNU\GnuPG\pub
	if exist "%ProgramFiles(x86)%\GNU\GnuPG" set myPATH=%myPATH%;%ProgramFiles(x86)%\GNU\GnuPG
@rem	if exist "%ProgramFiles%\ImgBurn" set myPATH=%myPATH%;%ProgramFiles%\ImgBurn
@rem	if exist "%ProgramFiles(x86)%\IrfanView" set myPATH=%myPATH%;%ProgramFiles(x86)%\IrfanView
	if exist "%ProgramFiles%\MediaInfo" set myPATH=%myPATH%;%ProgramFiles%\MediaInfo
	
@rem Some old bundles include an rsync built with an incompatible cygwin1.dll.
@rem These should be activated only in MinGW/MSYS. The Cygwin installer has an
@rem rsync package.
@rem Beware that CopSSH is a SSH server -- misconfigured and without a firewall
@rem it could become a backdoor.
@rem	if not exist "%CYGWIN_ROOT%" (
@rem		if exist "%ProgramFiles%\ICW" set myPATH=%myPATH%;%ProgramFiles%\ICW\bin
@rem		if exist "%ProgramFiles%\cwRsync" set myPATH=%myPATH%;%ProgramFiles%\cwRsync\bin
@rem		if exist "%ProgramFiles%\hardBackup" set myPATH=%myPATH%;%ProgramFiles%\hardBackup
@rem	)
	
rem OpenVPN provides openssl
	if exist "%ProgramFiles%\OpenVPN" set myPATH=%myPATH%;%ProgramFiles%\OpenVPN\bin
	if exist "%ProgramFiles%\Pandoc" set myPATH=%myPATH%;%ProgramFiles%\Pandoc\bin
rem WinSCP can provide pageant and puttygen, but not plink I guess
	if exist "%ProgramFiles(x86)%\PuTTY" (
		set myPATH=%myPATH%;%ProgramFiles(x86)%\PuTTY
	) else if exist "%ProgramFiles%\WinSCP\PuTTY" (
		set myPATH=%myPATH%;%ProgramFiles%\WinSCP\PuTTY
	) else if exist "%ProgramFiles%\WinSwitch\PuTTY" (
		set myPATH=%myPATH%;%ProgramFiles%\WinSwitch\PuTTY
	)
	if exist "%ProgramFiles%\Nmap" set myPATH=%myPATH%;%ProgramFiles%\Nmap
	if exist "%ProgramFiles%\Notepad++" set myPATH=%myPATH%;%ProgramFiles%\Notepad++
	if exist "%ProgramFiles%\smartmontools" set myPATH=%myPATH%;%ProgramFiles%\smartmontools\bin
rem for Subversion, see http://www.open.collab.net/downloads/subversion/
rem VMware comes with zip, unzip and mkisofs
	if exist "%ProgramFiles%\VMware\VMware Player" set myPATH=%myPATH%;%ProgramFiles%\VMware\VMware Player
	if exist "%ProgramFiles(x86)%\WinDirStat" set myPATH=%myPATH%;%ProgramFiles(x86)%\WinDirStat
	if exist "%ProgramFiles(x86)%\WinMerge-2.12.4" set myPATH=%myPATH%;%ProgramFiles(x86)%\WinMerge-2.12.4
	
	if defined myPATH (
		@rem myPATH begins with a superflous ; so the below is not a typo
		set oldPATH=%PATH%
		set PATH=%PATH%%myPATH%
	)
:PATHEXT OPTIONS
rem Files with these extensions are assumed to be executable by their
rem interpreter.
	if not defined PATHEXT (
		set PATHEXT=".COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH" 
	)
	set PATHEXT=%PATHEXT%;.ahk;.awk;.bash;.csh;.ipy;.jar;.pl;.py;.pyw;.sh;.tcsh
@rem Note that %PATHEXT:%%e;=% doesn't substitute %e inside a loop
@rem This will work:
@rem if /I "%PATHEXT:.ahk;=%" EQU "%PATHEXT%" (set myPATHEXT=%myPATHEXT%;.ahk)
@rem This will not:
@rem if /I "%PATHEXT:%e%;=%" EQU "%PATHEXT%" (set myPATHEXT=%myPATHEXT%;%e%)

:LOCAL OPTIONS
rem Machine-specific script:
	if exist "%WD%"\%HOSTNAME%.BAT (
		call "%WD%"\%HOSTNAME%.BAT
	) else if exist "%HOME%"\%HOSTNAME%.BAT (
		call "%HOME%"\%HOSTNAME%.BAT
	)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::EXECUTION::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	rem if defined DEBUG PATH

@rem Uncomment this line (and comment the one further down) if you want to
@rem trap based on exit status.
@rem if defined params (call %params%) else (call %SHELL%) || @pause
@rem	if defined params (call %params%) else (call %SHELL%)
	if defined params (
		start %params%
		exit
	) else if defined SHELL (
@rem Windows console seems to play nice with xterm-color
		if not defined %TERM% set TERM=xterm-color
		call %SHELL%
		exit
	) else (
		if exist "%MACROFILE%" (doskey /MACROFILE="%MACROFILE%")
		@ENDLOCAL
		call %ComSpec%
	)
	if defined DEBUG pause
:EOF
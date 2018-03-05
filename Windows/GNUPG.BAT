@echo OFF
REM spaces at the end of set commands invisibly fuck things up.
if not defined GNUPG_ROOT set GNUPG_ROOT=%ProgramFiles%\GNU\GnuPG\
if exist "%GNUPG_ROOT%" set PATH=%GNUPG_ROOT%;%PATH%
title GnuPG console
REM to add extra randomness on Windows 2000, enable diskperf -Y
REM diskperf -YD
doskey encrypt_file=gpg --symmetric --no-armor $*
doskey encrypt_text_file=gpg --symmetric --no-armor --textmode $*
REM doskey d=gpg --decrypt $*
doskey encrypt=gpg --armor --encrypt --sign $*
doskey encrypt_to_text=gpg --armor --textmode --encrypt --sign $*
doskey export=gpg --armor --export $*
doskey fetch=gpg --fetch-key $*
doskey generate=gpg --gen-key $*$Techo gpg --gen-revoke is a good idea now!
doskey help=doskey /macros
doskey import=gpg --import $*
doskey keys=cls$Tgpg --fingerprint --list-sigs $*
doskey mykeys=cls$Tgpg --list-secret-keys $*
doskey ntdecrypt=cipher /A /H $*
doskey quit=exit
doskey search=gpg --search-key $*
doskey signfile=gpg --no-armor --detach-sign $*
doskey signmessage=gpg -t --clearsign $*
doskey verifyfile=gpg --verify $*
doskey version=gpg --version $*
REM doskey md5sum=gpg --print-md md5 $*
REM doskey sha1sum=gpg --print-md sha1 $*
doskey /macros | sort
if defined TEMP (CD /D %TEMP%)
echo --- On Windows, ^^Z ends rather than ^^D ---
@echo ON
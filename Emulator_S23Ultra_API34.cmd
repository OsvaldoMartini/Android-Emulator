@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

SET EMULATOR=S23Ultra_API34
SET DEFAULT_SDK_PATH=C:\Android
SET CURRENT_FOLDER=%CD%
SET CUSTOM_CONFIG=%CURRENT_FOLDER%\%EMULATOR%\config.ini
SET USER_AVD_PATH=%USERPROFILE%\.android\avd

REM ============================================================
REM Check ANDROID_SDK_ROOT environment variable
REM ============================================================
set KEY=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
for /f "tokens=3*" %%a in ('reg query "%KEY%" /v ANDROID_SDK_ROOT 2^>nul') do (
    SET SDK_PATH=%%a
)

IF NOT DEFINED SDK_PATH (
    echo ANDROID_SDK_ROOT not found. Setting it to default: %DEFAULT_SDK_PATH%
    SET SDK_PATH=%DEFAULT_SDK_PATH%
    reg add "%KEY%" /v ANDROID_SDK_ROOT /t REG_EXPAND_SZ /d "%SDK_PATH%" /f >nul
) ELSE (
    echo Found ANDROID_SDK_ROOT: %SDK_PATH%
)

SET PATH=%SDK_PATH%\platform-tools;%SDK_PATH%\emulator;%PATH%

REM ============================================================
REM Create AVD if missing
REM ============================================================
"%SDK_PATH%\emulator\emulator.exe" -list-avds | findstr /i "%EMULATOR%" >nul
IF ERRORLEVEL 1 (
    echo AVD %EMULATOR% not found. Creating...
    echo no | avdmanager create avd -n "%EMULATOR%" -k "system-images;android-34;google_apis;x86_64" --device "pixel_7" --force
) ELSE (
    echo AVD %EMULATOR% already exists.
)

REM ============================================================
REM Backup original config.ini file
REM ============================================================
IF EXIST "%USER_AVD_PATH%\%EMULATOR%.avd\config.ini" (
    echo Backing up %EMULATOR% config.ini...
    copy /Y "%USER_AVD_PATH%\%EMULATOR%.avd\config.ini" "%USER_AVD_PATH%\%EMULATOR%.avd\config.ini.bak"
)

REM ============================================================
REM Copy custom config.ini file
REM ============================================================
IF EXIST "%CUSTOM_CONFIG%" (
    IF NOT EXIST "%USER_AVD_PATH%\%EMULATOR%.avd" mkdir "%USER_AVD_PATH%\%EMULATOR%.avd"
    copy /Y "%CUSTOM_CONFIG%" "%USER_AVD_PATH%\%EMULATOR%.avd\config.ini"
)

REM ============================================================
REM Kill old adb servers
REM ============================================================
echo Killing old ADB servers...
adb kill-server

REM ============================================================
REM Start the emulator
REM ============================================================
echo Starting emulator: %EMULATOR%
start "" "%SDK_PATH%\emulator\emulator.exe" -avd %EMULATOR% -no-snapshot-load

REM ============================================================
REM Wait for emulator to boot
REM ============================================================
echo Waiting for emulator to boot...

:WAIT_LOOP
SET EMU_OK=0

FOR /F "tokens=1,2" %%i IN ('adb devices ^| findstr emulator') DO (
    IF "%%j"=="device" SET EMU_OK=1
)

IF "%EMU_OK%"=="1" GOTO CONNECTED

timeout /t 5 >nul
GOTO WAIT_LOOP

:CONNECTED
echo ============================================================
echo Emulator %EMULATOR% is online!
adb devices
echo ============================================================
echo You can now run adb commands or start your tests.
pause

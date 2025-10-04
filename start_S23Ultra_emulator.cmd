@echo off
REM ============================================================
REM Script: start_two_emulators.cmd
REM Purpose: Create (if missing) and start two emulators,
REM          backup config.ini, and copy custom configs
REM ============================================================

SET EMULATOR_1=S23Ultra_API34
SET EMULATOR_2=Pixel_8_API34
SET DEFAULT_SDK_PATH=D:\Android
SET CUSTOM_CONFIG_EMU1="D:\Projects\Android-Emulator\S23Ultra_API34\config.ini"
SET CUSTOM_CONFIG_EMU2="D:\Projects\Android-Emulator\Pixel_8_API34\config.ini"

SET USER_AVD_PATH=%USERPROFILE%\.android\avd

REM ============================================================
REM Check if ANDROID_SDK_ROOT system environment variable exists
REM ============================================================
set KEY=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
for /f "tokens=3*" %%a in ('reg query "%KEY%" /v ANDROID_SDK_ROOT 2^>nul') do (
    SET SDK_PATH=%%a
)

IF NOT DEFINED SDK_PATH (
    echo ANDROID_SDK_ROOT not found. Setting it to default: %DEFAULT_SDK_PATH%
    SET SDK_PATH=%DEFAULT_SDK_PATH%
    
    REM Set system environment variable (requires admin privileges)
    reg add "%KEY%" /v ANDROID_SDK_ROOT /t REG_EXPAND_SZ /d "%SDK_PATH%" /f >nul
) ELSE (
    echo Found ANDROID_SDK_ROOT: %SDK_PATH%
)

REM Add SDK tools to PATH for this session
SET PATH=%SDK_PATH%\platform-tools;%SDK_PATH%\emulator;%PATH%

REM ============================================================
REM Check if AVDs exist, create if missing
REM ============================================================
FOR %%E IN (%EMULATOR_1% %EMULATOR_2%) DO (
    "%SDK_PATH%\emulator\emulator.exe" -list-avds | findstr /i "%%E" >nul
    IF ERRORLEVEL 1 (
        echo AVD %%E not found. Creating...
		IF "%%E"=="%EMULATOR_1%" (
			echo no | avdmanager create avd -n "%EMULATOR_1%" -k "system-images;android-34;google_apis;x86_64" --device "pixel_7" --force
		) ELSE (
			echo no | avdmanager create avd -n "%EMULATOR_2%" -k "system-images;android-34;google_apis;x86_64" --device "pixel_8" --force
		)
    ) ELSE (
        echo AVD %%E already exists.
    )
)

REM ============================================================
REM Backup original config.ini files
REM ============================================================
FOR %%E IN (%EMULATOR_1% %EMULATOR_2%) DO (
    IF EXIST "%USER_AVD_PATH%\%%E.avd\config.ini" (
        echo Backing up %%E config.ini...
        copy /Y "%USER_AVD_PATH%\%%E.avd\config.ini" "%USER_AVD_PATH%\%%E.avd\config.ini.bak"
    )
)

REM ============================================================
REM Copy custom config.ini for each emulator
REM ============================================================
IF EXIST %CUSTOM_CONFIG_EMU1% (
    IF NOT EXIST "%USER_AVD_PATH%\%EMULATOR_1%.avd" mkdir "%USER_AVD_PATH%\%EMULATOR_1%.avd"
    copy /Y %CUSTOM_CONFIG_EMU1% "%USER_AVD_PATH%\%EMULATOR_1%.avd\config.ini"
)

IF EXIST %CUSTOM_CONFIG_EMU2% (
    IF NOT EXIST "%USER_AVD_PATH%\%EMULATOR_2%.avd" mkdir "%USER_AVD_PATH%\%EMULATOR_2%.avd"
    copy /Y %CUSTOM_CONFIG_EMU2% "%USER_AVD_PATH%\%EMULATOR_2%.avd\config.ini"
)

REM ============================================================
echo Killing old ADB servers...
adb kill-server

REM ============================================================
echo Starting emulator: %EMULATOR_1%
start "" "%SDK_PATH%\emulator\emulator.exe" -avd %EMULATOR_1% -no-snapshot-load

echo Starting emulator: %EMULATOR_2%
start "" "%SDK_PATH%\emulator\emulator.exe" -avd %EMULATOR_2% -no-snapshot-load

REM ============================================================
echo Waiting for both emulators to boot...

:WAIT_LOOP
SET EMU1_OK=0
SET EMU2_OK=0

FOR /F "tokens=1,2" %%i IN ('adb devices ^| findstr emulator') DO (
    IF "%%j"=="device" (
        IF "%%i"=="emulator-5554" SET EMU1_OK=1
        IF "%%i"=="emulator-5556" SET EMU2_OK=1
    )
)

IF "%EMU1_OK%"=="1" IF "%EMU2_OK%"=="1" GOTO CONNECTED

REM Wait 5 seconds before checking again
timeout /t 5 >nul
GOTO WAIT_LOOP

:CONNECTED
echo ============================================================
echo Both emulators are online!
adb devices
echo ============================================================
echo You can now run adb commands or start your tests.
pause

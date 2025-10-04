@echo off
REM ============================================================
REM Script: start_S23Ultra_emulator.cmd
REM Purpose: Start Galaxy S23 Ultra emulator and ensure ADB connection
REM ============================================================

SET EMULATOR_NAME=S23Ultra_API34
SET SDK_PATH=C:\Android
SET PATH=%SDK_PATH%\platform-tools;%SDK_PATH%\emulator;%PATH%

echo ============================================================
echo Killing old ADB servers...
adb kill-server

echo ============================================================
echo Starting emulator: %EMULATOR_NAME%
start "" "%SDK_PATH%\emulator\emulator.exe" -avd %EMULATOR_NAME% -no-snapshot-load

echo ============================================================
echo Waiting for emulator to boot...

:WAIT_LOOP
REM Check if emulator is listed and online
FOR /F "tokens=1,2" %%i IN ('adb devices ^| findstr emulator') DO (
    IF "%%j"=="device" (
        echo Emulator is online!
        GOTO CONNECTED
    )
)
REM Wait 5 seconds before checking again
timeout /t 5 >nul
GOTO WAIT_LOOP

:CONNECTED
echo ============================================================
echo Emulator %EMULATOR_NAME% is ready and connected via ADB!
adb devices
echo ============================================================
echo You can now run adb commands or start your tests.
pause

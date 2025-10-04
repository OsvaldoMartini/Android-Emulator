@echo off
REM ============================================================
REM Script: start_S23Ultra_emulator.cmd
REM Purpose: Start Galaxy S23 Ultra emulator and ensure ADB connection
REM ============================================================

SET EMULATOR_NAME=S23Ultra_API34
SET DEFAULT_SDK_PATH=D:\Android

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

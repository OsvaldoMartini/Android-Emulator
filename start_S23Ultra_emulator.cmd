@echo off
REM ============================================================
REM Script: start_two_emulators.cmd
REM Purpose: Start two emulators and ensure both ADB connections
REM ============================================================

SET EMULATOR_1=S23Ultra_API34
SET EMULATOR_2=Pixel_7_API34
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
echo Starting emulator: %EMULATOR_1%
start "" "%SDK_PATH%\emulator\emulator.exe" -avd %EMULATOR_1% -no-snapshot-load

echo Starting emulator: %EMULATOR_2%
start "" "%SDK_PATH%\emulator\emulator.exe" -avd %EMULATOR_2% -no-snapshot-load

echo ============================================================
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

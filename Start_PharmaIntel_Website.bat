@echo off
setlocal EnableDelayedExpansion
title PharmaIntel India - Launcher
color 0A

echo =======================================================================
echo          PHARMAINTELLIGENCE INDIA - INDEPENDENT LAUNCHER
echo =======================================================================
echo.

set "PROJECT_DIR=C:\Users\arpan\.gemini\antigravity\scratch\pharma-market-intelligence"
cd /d "%PROJECT_DIR%"

:: 1. Locate Python executable with fallback
set "PYTHON_EXE=C:\Users\arpan\AppData\Local\Programs\Python\Python313\python.exe"
if not exist "!PYTHON_EXE!" (
    where python >nul 2>nul
    if !ERRORLEVEL! equ 0 (
        for /f "delims=" %%I in ('where python') do (
            if not defined PYTHON_EXE set "PYTHON_EXE=%%I"
        )
    ) else (
        echo [ERROR] Python not found on system! Please ensure Python is installed.
        pause
        exit /b 1
    )
)

:: 2. Check if port 5000 is already active
echo [*] Checking if PharmaIntel is already running on port 5000...
netstat -ano | findstr :5000 | findstr LISTENING >nul
if %ERRORLEVEL% equ 0 (
    echo [OK] Server is ALREADY running and active on port 5000!
    echo [*] No duplicate instance needed.
    goto OPEN_BROWSER
)

:: 3. Start server in background
echo [*] Starting PharmaIntel server in background...
start "" /b "!PYTHON_EXE!" app.py > app_server.log 2>&1

:: 4. Wait for server to bind to port 5000 (up to 10 seconds)
echo [*] Waiting for server initialization...
set /a attempts=0
:WAIT_LOOP
set /a attempts+=1
ping 127.0.0.1 -n 2 >nul
netstat -ano | findstr :5000 | findstr LISTENING >nul
if %ERRORLEVEL% equ 0 goto SERVER_READY
if !attempts! geq 10 (
    echo [!] Server taking longer than usual. Opening browser anyway...
    goto OPEN_BROWSER
)
goto WAIT_LOOP

:SERVER_READY
echo [SUCCESS] PharmaIntel Server is running live on http://localhost:5000

:OPEN_BROWSER
echo [*] Opening PharmaIntel dashboard in your default web browser...
start "" "http://localhost:5000"

echo.
echo =======================================================================
echo   Platform is running live at http://localhost:5000
echo   This window will automatically close in 3 seconds.
echo =======================================================================
ping 127.0.0.1 -n 3 >nul
exit /b 0

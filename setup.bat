@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   Turbo CLI Setup
echo ========================================
echo.

REM Check for LFS pointers (downloaded via ZIP instead of git clone)
findstr /C:"version https://git-lfs.github.com" src\turbo\bin\*.dll src\turbo\data\engine.zip 2>nul >nul
if not errorlevel 1 (
    echo [ERROR] Detected Git LFS pointer files!
    echo.
    echo You downloaded the repository via "Download ZIP" instead of git clone.
    echo LFS pointer files are NOT the actual binaries.
    echo.
    echo Please run these commands instead:
    echo   git clone https://github.com/md-exitcode0/turbo-cli.git
    echo   cd turbo-cli
    echo   setup.bat
    echo.
    pause
    exit /b 1
)

REM Check Python using py launcher
py --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Install from python.org
    pause
    exit /b 1
)

echo Step 1: Bundling engine...
py package_engine.py >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to bundle engine
    pause
    exit /b 1
)

echo Step 2: Installing...
py -m pip install -e . >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Installation failed
    pause
    exit /b 1
)

echo Step 3: Verifying...
turbo --help >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Verification failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Run 'turbo launch' to start the server.
echo.
pause

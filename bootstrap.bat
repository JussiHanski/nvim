@echo off
setlocal enabledelayedexpansion

:: Configuration
set "REPO_URL=https://github.com/JussiHanski/nvim.git"
set "INSTALL_DIR=%USERPROFILE%\.config\nvim_config_tool"
set "TOOL_SCRIPT=%INSTALL_DIR%\scripts\nvim-tool.bat"

:: Parse command
set "COMMAND=%~1"
if "%COMMAND%"=="" set "COMMAND=help"

if /i "%COMMAND%"=="init" goto :init_cmd
if /i "%COMMAND%"=="update" goto :delegate_cmd
if /i "%COMMAND%"=="clean" goto :delegate_cmd
if /i "%COMMAND%"=="status" goto :delegate_cmd
if /i "%COMMAND%"=="help" goto :show_help
if /i "%COMMAND%"=="--help" goto :show_help
if /i "%COMMAND%"=="-h" goto :show_help

echo Error: Unknown command: %COMMAND%
goto :show_help

:init_cmd
call :check_git
if errorlevel 1 exit /b 1
call :clone_or_update_repo
if errorlevel 1 exit /b 1
goto :delegate_cmd

:delegate_cmd
call :check_git
if errorlevel 1 exit /b 1

:: Check if tool script exists
if not exist "%TOOL_SCRIPT%" (
    if /i "%COMMAND%"=="init" (
        echo Error: Tool script not found at %TOOL_SCRIPT% after cloning
        exit /b 1
    ) else (
        echo Error: Repository not initialized. Run: %~nx0 init
        exit /b 1
    )
)

:: Delegate to the main tool
call "%TOOL_SCRIPT%" %*
exit /b %errorlevel%

:check_git
where git >nul 2>&1
if errorlevel 1 (
    echo Error: Git is not installed. Please install git first.
    echo Download from: https://git-scm.com/download/win
    exit /b 1
)
exit /b 0

:clone_or_update_repo
if exist "%INSTALL_DIR%" (
    echo Repository already exists at %INSTALL_DIR%
    echo Pulling latest changes...

    cd /d "%INSTALL_DIR%"

    :: Stash any local changes
    git diff-index --quiet HEAD -- 2>nul
    if errorlevel 1 (
        echo Stashing local changes...
        for /f "tokens=1-3 delims=/ " %%a in ('echo %date%') do set "DATESTAMP=%%c%%a%%b"
        for /f "tokens=1-2 delims=:. " %%a in ('echo %time%') do set "TIMESTAMP=%%a%%b"
        git stash push -m "Auto-stash before init %DATESTAMP%_%TIMESTAMP%"
    )

    :: Pull latest
    git pull origin main
    if errorlevel 1 (
        echo Error: Failed to pull latest changes
        exit /b 1
    )

    echo Repository updated to latest version
    exit /b 0
)

echo Cloning repository to %INSTALL_DIR%...

:: Create parent directory if it doesn't exist
if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"

git clone "%REPO_URL%" "%INSTALL_DIR%"
if errorlevel 1 (
    echo Error: Failed to clone repository
    exit /b 1
)

echo Repository cloned successfully
exit /b 0

:show_help
echo Neovim Configuration Tool - Bootstrap Script
echo.
echo Usage: %~nx0 ^<command^>
echo.
echo Commands:
echo     init        Initialize Neovim configuration (first-time setup)
echo     update      Update to latest configuration
echo     clean       Remove configuration and restore backup
echo     status      Show configuration status
echo     help        Show this help message
echo.
echo After initial setup, you can use the tool directly:
echo     %TOOL_SCRIPT% ^<command^>
echo.
exit /b 0

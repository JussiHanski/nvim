@echo off
setlocal enabledelayedexpansion

:: Configuration
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
for %%i in ("%SCRIPT_DIR%\..") do set "REPO_DIR=%%~fi"
set "NVIM_SOURCE_DIR=%REPO_DIR%\nvim"
set "NVIM_CONFIG_DIR=%LOCALAPPDATA%\nvim"

:: Parse command
set "COMMAND=%~1"
if "%COMMAND%"=="" set "COMMAND=help"

if /i "%COMMAND%"=="init" goto :cmd_init
if /i "%COMMAND%"=="update" goto :cmd_update
if /i "%COMMAND%"=="clean" goto :cmd_clean
if /i "%COMMAND%"=="status" goto :cmd_status
if /i "%COMMAND%"=="help" goto :show_help
if /i "%COMMAND%"=="--help" goto :show_help
if /i "%COMMAND%"=="-h" goto :show_help

echo Error: Unknown command: %COMMAND%
goto :show_help

:cmd_init
echo Initializing Neovim configuration...
echo.

:: Auto-install optional dependencies during init
call :check_dependencies auto
if errorlevel 1 exit /b 1

call :check_nvim_installed

:: Check if nvim source directory exists
if not exist "%NVIM_SOURCE_DIR%" (
    echo Error: Neovim configuration directory not found at %NVIM_SOURCE_DIR%
    echo Please ensure the repository is properly set up
    exit /b 1
)

call :backup_existing_config
call :create_symlink
if errorlevel 1 exit /b 1
call :install_plugins

echo.
echo Initialization complete!
echo You can now start Neovim with: nvim
exit /b 0

:cmd_update
echo Updating Neovim configuration...
echo.

:: Check if already initialized
if not exist "%NVIM_CONFIG_DIR%" (
    echo Error: Configuration not initialized. Run: init
    exit /b 1
)

:: For Windows, check if it's a junction or symlink
fsutil reparsepoint query "%NVIM_CONFIG_DIR%" >nul 2>&1
if errorlevel 1 (
    echo Error: Configuration not initialized. Run: init
    exit /b 1
)

cd /d "%REPO_DIR%"

:: Check for uncommitted changes
git diff-index --quiet HEAD -- 2>nul
if errorlevel 1 (
    echo Warning: You have uncommitted changes
    git status --short
    set /p "REPLY=Stash changes and continue? (y/n): "
    if /i not "!REPLY!"=="y" (
        echo Update cancelled
        exit /b 1
    )

    for /f "tokens=1-3 delims=/ " %%a in ('echo %date%') do set "DATESTAMP=%%c%%a%%b"
    for /f "tokens=1-2 delims=: " %%a in ('echo %time%') do set "TIMESTAMP=%%a%%b"
    git stash push -m "Auto-stash before update %DATESTAMP%_%TIMESTAMP%"
    echo Changes stashed
)

:: Pull latest changes
echo Pulling latest changes...
for /f %%i in ('git rev-parse HEAD') do set "BEFORE_HASH=%%i"
git pull origin main
for /f %%i in ('git rev-parse HEAD') do set "AFTER_HASH=%%i"

:: If script was updated, re-execute with the new version
if not "%BEFORE_HASH%"=="%AFTER_HASH%" (
    if not defined NVIM_TOOL_REEXEC (
        echo Scripts updated, re-running with latest version...
        set "NVIM_TOOL_REEXEC=1"
        call "%~f0" update
        exit /b !errorlevel!
    )
)

call :check_dependencies
call :check_nvim_installed

:: Update plugins
echo Updating plugins...
nvim --headless "+Lazy! sync" +qa 2>nul

echo.
echo Update complete!
echo.
echo Recent changes:
git log --oneline -5

exit /b 0

:cmd_clean
echo Warning: This will remove the Neovim configuration symlink
set /p "REPLY=Continue? (y/n): "
if /i not "%REPLY%"=="y" (
    echo Clean cancelled
    exit /b 0
)

:: Remove symlink/junction
if exist "%NVIM_CONFIG_DIR%" (
    fsutil reparsepoint query "%NVIM_CONFIG_DIR%" >nul 2>&1
    if not errorlevel 1 (
        rmdir "%NVIM_CONFIG_DIR%"
        echo Symlink removed
    ) else (
        echo No symlink found at %NVIM_CONFIG_DIR%
    )
)

:: Optionally restore backup
if exist "%REPO_DIR%\.last_backup" (
    set /p LAST_BACKUP=<"%REPO_DIR%\.last_backup"
    if exist "!LAST_BACKUP!" (
        set /p "REPLY=Restore backup from !LAST_BACKUP!? (y/n): "
        if /i "!REPLY!"=="y" (
            move /y "!LAST_BACKUP!" "%NVIM_CONFIG_DIR%" >nul
            echo Backup restored
            del "%REPO_DIR%\.last_backup"
        )
    )
)

echo Clean complete
exit /b 0

:cmd_status
echo Neovim Configuration Tool Status
echo.

:: Check symlink/junction
if exist "%NVIM_CONFIG_DIR%" (
    fsutil reparsepoint query "%NVIM_CONFIG_DIR%" >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=3" %%i in ('fsutil reparsepoint query "%NVIM_CONFIG_DIR%" ^| findstr /C:"Print Name:"') do (
            echo [OK] Symlink: %NVIM_CONFIG_DIR% -^> %%i
        )
    ) else (
        echo [!] No symlink found at %NVIM_CONFIG_DIR%
    )
) else (
    echo [!] No symlink found at %NVIM_CONFIG_DIR%
)

echo.

:: Check Neovim installation and version
where nvim >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('nvim --version ^| findstr /C:"NVIM"') do (
        echo [OK] Neovim: %%i
    )
) else (
    echo [!] Neovim: Not installed
)

echo.

:: Check dependencies
echo Dependencies:
call :check_dependencies

:: Git status
cd /d "%REPO_DIR%"
echo.
echo Git Status:
git status --short

echo.
echo Recent commits:
git log --oneline -5

exit /b 0

:check_dependencies
set "AUTO_INSTALL_OPTIONAL=%~1"

echo Checking dependencies...

set "MISSING_CRITICAL="
set "MISSING_OPTIONAL="

:: Check git
where git >nul 2>&1
if not errorlevel 1 (
    echo [OK] git found
) else (
    set "MISSING_CRITICAL=!MISSING_CRITICAL! git"
)

:: Check make
where make >nul 2>&1
if not errorlevel 1 (
    echo [OK] make found
) else (
    set "MISSING_CRITICAL=!MISSING_CRITICAL! make"
)

:: Check unzip
where unzip >nul 2>&1
if not errorlevel 1 (
    echo [OK] unzip found
) else (
    where tar >nul 2>&1
    if not errorlevel 1 (
        echo [OK] tar found (can extract archives)
    ) else (
        set "MISSING_CRITICAL=!MISSING_CRITICAL! unzip"
    )
)

:: Check C compiler
where gcc >nul 2>&1
if not errorlevel 1 (
    echo [OK] gcc found
    goto :compiler_ok
)
where clang >nul 2>&1
if not errorlevel 1 (
    echo [OK] clang found
    goto :compiler_ok
)
where cl >nul 2>&1
if not errorlevel 1 (
    echo [OK] MSVC (cl.exe) found
    goto :compiler_ok
)
set "MISSING_CRITICAL=!MISSING_CRITICAL! gcc/clang/msvc"
:compiler_ok

:: Check ripgrep
where rg >nul 2>&1
if not errorlevel 1 (
    echo [OK] ripgrep found
) else (
    set "MISSING_CRITICAL=!MISSING_CRITICAL! ripgrep"
)

:: Check optional dependencies
where fd >nul 2>&1
if not errorlevel 1 (
    echo [OK] fd found
) else (
    set "MISSING_OPTIONAL=!MISSING_OPTIONAL! fd"
)

where cargo >nul 2>&1
if not errorlevel 1 (
    echo [OK] cargo found
) else (
    set "MISSING_OPTIONAL=!MISSING_OPTIONAL! cargo"
)

where node >nul 2>&1
if not errorlevel 1 (
    echo [OK] node found
) else (
    set "MISSING_OPTIONAL=!MISSING_OPTIONAL! node"
)

where npm >nul 2>&1
if not errorlevel 1 (
    echo [OK] npm found
) else (
    set "MISSING_OPTIONAL=!MISSING_OPTIONAL! npm"
)

:: Report critical dependencies
if not "%MISSING_CRITICAL%"=="" (
    echo.
    echo Error: Missing critical dependencies:%MISSING_CRITICAL%

    :: Check if winget is available
    where winget >nul 2>&1
    if errorlevel 1 (
        echo.
        echo [!] winget is not available. Please install dependencies manually:
        call :show_manual_instructions
        exit /b 1
    )

    echo.
    set /p "REPLY=Would you like to install missing dependencies using winget (y/n): "
    if /i not "!REPLY!"=="y" (
        call :show_manual_instructions
        exit /b 1
    )

    call :install_with_winget
    if errorlevel 1 (
        echo Some dependencies could not be installed automatically.
        call :show_manual_instructions
        exit /b 1
    )

    echo.
    echo [OK] Dependencies installed successfully!
    echo Please restart your terminal to refresh PATH, then run this script again.
    exit /b 0
)

:: Report optional dependencies
if not "%MISSING_OPTIONAL%"=="" (
    echo.
    echo [!] Missing optional dependencies:%MISSING_OPTIONAL%

    :: Check if winget is available
    where winget >nul 2>&1
    if errorlevel 1 (
        echo These are optional but recommended for better performance
        call :show_optional_manual_instructions
        goto :end_optional_check
    )

    :: Auto-install if requested (during init), otherwise ask
    if /i "%AUTO_INSTALL_OPTIONAL%"=="auto" (
        echo Installing optional dependencies with winget...
        call :install_optional_with_winget
        echo [OK] Optional dependencies installation complete!
        goto :end_optional_check
    )

    set /p "REPLY=Would you like to install optional dependencies using winget (y/n): "
    if /i "!REPLY!"=="y" (
        call :install_optional_with_winget
    ) else (
        echo These are optional but recommended for better performance
        call :show_optional_manual_instructions
    )
)
:end_optional_check

echo.
echo [OK] All critical dependencies found
exit /b 0

:install_with_winget
echo.
echo Installing dependencies with winget...
set "INSTALL_FAILED="

:: Install git
echo !MISSING_CRITICAL! | findstr /C:"git" >nul
if not errorlevel 1 (
    echo Installing Git...
    winget install -e --id Git.Git --silent --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo [!] Failed to install Git
        set "INSTALL_FAILED=!INSTALL_FAILED! git"
    ) else (
        echo [OK] Git installed
    )
)

:: Install make (via MSYS2)
echo !MISSING_CRITICAL! | findstr /C:"make" >nul
if not errorlevel 1 (
    echo Installing MSYS2 (includes make)...
    winget install -e --id MSYS2.MSYS2 --silent --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo [!] Failed to install MSYS2
        set "INSTALL_FAILED=!INSTALL_FAILED! make"
    ) else (
        echo [OK] MSYS2 installed
        echo [!] After restart, run: pacman -S make
    )
)

:: Install ripgrep
echo !MISSING_CRITICAL! | findstr /C:"ripgrep" >nul
if not errorlevel 1 (
    echo Installing ripgrep...
    winget install -e --id BurntSushi.ripgrep.MSVC --silent --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo [!] Failed to install ripgrep
        set "INSTALL_FAILED=!INSTALL_FAILED! ripgrep"
    ) else (
        echo [OK] ripgrep installed
    )
)

:: Install C compiler (Visual Studio Build Tools)
echo !MISSING_CRITICAL! | findstr /C:"gcc/clang/msvc" >nul
if not errorlevel 1 (
    echo Installing Visual Studio Build Tools...
    winget install -e --id Microsoft.VisualStudio.2022.BuildTools --silent --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo [!] Failed to install Visual Studio Build Tools
        set "INSTALL_FAILED=!INSTALL_FAILED! compiler"
    ) else (
        echo [OK] Visual Studio Build Tools installed
    )
)

if not "%INSTALL_FAILED%"=="" (
    echo.
    echo [!] Failed to install:%INSTALL_FAILED%
    exit /b 1
)

exit /b 0

:install_optional_with_winget
echo.
echo Installing optional dependencies with winget...

:: Install fd
echo !MISSING_OPTIONAL! | findstr /C:"fd" >nul
if not errorlevel 1 (
    echo Installing fd...
    winget install -e --id sharkdp.fd --silent --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo [!] Failed to install fd
    ) else (
        echo [OK] fd installed
    )
)

:: Install Rust (includes cargo)
echo !MISSING_OPTIONAL! | findstr /C:"cargo" >nul
if not errorlevel 1 (
    echo Installing Rust (includes cargo)...
    winget install -e --id Rustlang.Rust.MSVC --silent --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo [!] Failed to install Rust
    ) else (
        echo [OK] Rust installed
    )
)

:: Install Node.js (includes npm)
echo !MISSING_OPTIONAL! | findstr /C:"node" >nul
if not errorlevel 1 (
    echo Installing Node.js (includes npm)...
    winget install -e --id OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo [!] Failed to install Node.js
    ) else (
        echo [OK] Node.js installed
    )
)

echo.
echo [OK] Optional dependencies installation complete!
echo Please restart your terminal to refresh PATH.
exit /b 0

:show_manual_instructions
echo.
echo Manual installation instructions:
echo   - Git: https://git-scm.com/download/win
echo   - Make: Install MSYS2 from https://www.msys2.org/ then run: pacman -S make
echo   - Ripgrep: https://github.com/BurntSushi/ripgrep/releases
echo   - C Compiler: Install Visual Studio Build Tools from https://visualstudio.microsoft.com/downloads/
exit /b 0

:show_optional_manual_instructions
echo   - fd: https://github.com/sharkdp/fd/releases
echo   - cargo: https://rustup.rs/
echo   - node/npm: https://nodejs.org/
exit /b 0

:check_nvim_installed
where nvim >nul 2>&1
if errorlevel 1 (
    echo [!] Neovim is not installed.

    :: Check if winget is available
    where winget >nul 2>&1
    if not errorlevel 1 (
        set /p "REPLY=Would you like to install Neovim using winget? (y/n): "
        if /i "!REPLY!"=="y" (
            echo Installing Neovim...
            winget install -e --id Neovim.Neovim --silent --accept-source-agreements --accept-package-agreements
            if errorlevel 1 (
                echo [!] Failed to install Neovim
                echo Please install manually from: https://github.com/neovim/neovim/releases
                exit /b 0
            )
            echo [OK] Neovim installed successfully!
            echo Please restart your terminal to refresh PATH, then run this script again.
            exit /b 0
        )
    )

    echo Please install Neovim from: https://github.com/neovim/neovim/releases
    echo After installation, add it to your PATH and run this script again.
    exit /b 0
)

for /f "tokens=*" %%i in ('nvim --version ^| findstr /C:"NVIM"') do (
    echo [OK] Neovim is installed: %%i
)
exit /b 0

:backup_existing_config
if exist "%NVIM_CONFIG_DIR%" (
    :: Check if it's a symlink/junction
    fsutil reparsepoint query "%NVIM_CONFIG_DIR%" >nul 2>&1
    if not errorlevel 1 (
        echo Neovim config is already a symlink
        for /f "tokens=3" %%i in ('fsutil reparsepoint query "%NVIM_CONFIG_DIR%" ^| findstr /C:"Print Name:"') do (
            if "%%i"=="%NVIM_SOURCE_DIR%" (
                echo Neovim config already points to this repository
                exit /b 0
            ) else (
                echo Warning: Neovim config is a symlink to: %%i
                set /p "REPLY=Remove this symlink and create a new one? (y/n): "
                if /i not "!REPLY!"=="y" (
                    echo Error: Cannot proceed without removing existing symlink
                    exit /b 1
                )
                rmdir "%NVIM_CONFIG_DIR%"
            )
        )
    ) else (
        :: It's a regular directory, back it up
        for /f "tokens=1-3 delims=/ " %%a in ('echo %date%') do set "DATESTAMP=%%c%%a%%b"
        for /f "tokens=1-2 delims=:. " %%a in ('echo %time%') do set "TIMESTAMP=%%a%%b"
        set "BACKUP_DIR=%NVIM_CONFIG_DIR%.backup.%DATESTAMP%_%TIMESTAMP%"

        echo Backing up existing config to !BACKUP_DIR!
        move "%NVIM_CONFIG_DIR%" "!BACKUP_DIR!" >nul
        echo Backup created at !BACKUP_DIR!

        echo !BACKUP_DIR!> "%REPO_DIR%\.last_backup"
    )
)
exit /b 0

:create_symlink
echo Creating symlink: %NVIM_CONFIG_DIR% -^> %NVIM_SOURCE_DIR%

:: Create parent directory if it doesn't exist
if not exist "%LOCALAPPDATA%" mkdir "%LOCALAPPDATA%"

:: Create junction (works without admin rights on Windows)
mklink /J "%NVIM_CONFIG_DIR%" "%NVIM_SOURCE_DIR%" >nul
if errorlevel 1 (
    echo Error: Failed to create symlink. Try running as administrator.
    exit /b 1
)

echo Symlink created successfully
exit /b 0

:install_plugins
echo Installing plugins...

if not exist "%NVIM_SOURCE_DIR%\init.lua" (
    echo [!] No init.lua found, skipping plugin installation
    exit /b 0
)

:: Run Neovim headless to trigger lazy.nvim installation and plugin sync
nvim --headless "+Lazy! sync" +qa 2>nul

echo Plugins installed
exit /b 0

:show_help
echo Neovim Configuration Tool
echo.
echo Usage: %~nx0 ^<command^>
echo.
echo Commands:
echo     init                Initialize Neovim configuration (first-time setup)
echo     update              Update to latest configuration
echo     clean               Remove configuration and restore backup
echo     status              Show configuration status
echo     help                Show this help message
echo.
echo Examples:
echo     %~nx0 init
echo     %~nx0 update
echo     %~nx0 status
echo     %~nx0 clean
echo.
echo Configuration:
echo     Repository:  %REPO_DIR%
echo     Config Dir:  %NVIM_CONFIG_DIR%
echo     Source Dir:  %NVIM_SOURCE_DIR%
echo.
exit /b 0

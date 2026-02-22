@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ==============================================================
REM SourceBridge one-click automation script for Windows
REM - Prepares folders
REM - Syncs git repository + submodules
REM - Attempts dependency restore/build for known toolchains
REM - Optionally starts srcds if available
REM ==============================================================

set "ROOT=%~dp0"
cd /d "%ROOT%"

set "LOG_DIR=%ROOT%logs"
set "BUILD_DIR=%ROOT%build"
set "SERVER_DIR=%ROOT%server"
set "LOG_FILE=%LOG_DIR%\automation.log"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%SERVER_DIR%" mkdir "%SERVER_DIR%"

echo =============================================================
echo   SourceBridge automation started at %DATE% %TIME%
echo =============================================================
>> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo [%DATE% %TIME%] Start

call :runStep "Validate git repository" "git rev-parse --is-inside-work-tree"
if errorlevel 1 goto :fail

call :runStep "Fetch latest changes" "git fetch --all --prune"
if errorlevel 1 goto :fail

call :runStep "Fast-forward pull" "git pull --ff-only"
if errorlevel 1 goto :fail

call :runStep "Update submodules" "git submodule update --init --recursive"
if errorlevel 1 goto :fail

if exist "%ROOT%package.json" (
  call :runStep "Install Node dependencies" "npm install"
  if errorlevel 1 goto :fail

  if exist "%ROOT%package-lock.json" (
    call :runStep "Run npm build" "npm run build"
    if errorlevel 1 goto :fail
  )
)

if exist "%ROOT%*.sln" (
  call :runStep "Restore NuGet packages" "dotnet restore"
  if errorlevel 1 goto :fail

  call :runStep "Build .NET solution (Release)" "dotnet build -c Release"
  if errorlevel 1 goto :fail
)

if exist "%SERVER_DIR%\srcds.exe" (
  echo.
  set /p "START_SERVER=Start dedicated server now? (Y/N): "
  if /I "!START_SERVER!"=="Y" (
    call :runStep "Start srcds" "\"%SERVER_DIR%\srcds.exe\" -game tf +map ctf_2fort +maxplayers 24"
    if errorlevel 1 goto :fail
  )
)

echo.
echo [SUCCESS] Automation completed.
>> "%LOG_FILE%" echo [%DATE% %TIME%] Completed successfully
exit /b 0

:runStep
set "STEP_NAME=%~1"
set "STEP_CMD=%~2"
echo.
echo [STEP] %STEP_NAME%
echo [CMD ] %STEP_CMD%
>> "%LOG_FILE%" echo [%DATE% %TIME%] STEP: %STEP_NAME%
>> "%LOG_FILE%" echo [%DATE% %TIME%] CMD : %STEP_CMD%

call %STEP_CMD% >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
  echo [FAIL] %STEP_NAME%
  >> "%LOG_FILE%" echo [%DATE% %TIME%] FAIL: %STEP_NAME%
  exit /b 1
)

echo [ OK ] %STEP_NAME%
>> "%LOG_FILE%" echo [%DATE% %TIME%] PASS: %STEP_NAME%
exit /b 0

:fail
echo.
echo [ERROR] Automation stopped. See log: "%LOG_FILE%"
>> "%LOG_FILE%" echo [%DATE% %TIME%] Stopped with errors
exit /b 1

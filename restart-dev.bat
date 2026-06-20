@echo off
title AI Murder Mystery - Dev Server

echo === Kill old processes on port 10000 and 3000 ===
for /f "tokens=5" %%a in ('netstat.exe -ano ^| findstr.exe /R ":10000 .*LISTENING"') do (
    echo   Killing port 10000 PID=%%a
    taskkill.exe /f /pid %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat.exe -ano ^| findstr.exe /R ":3000 .*LISTENING"') do (
    echo   Killing port 3000 PID=%%a
    taskkill.exe /f /pid %%a >nul 2>&1
)
timeout /t 3 >nul

echo.
echo === Start Backend (port 10000) ===
pushd "%~dp0api"
start "Backend" cmd /c "pipenv run uvicorn main:app --host 0.0.0.0 --port 10000"
popd

timeout /t 3 >nul

echo.
echo === Start Frontend (port 3000) ===
pushd "%~dp0web"
start "Frontend" cmd /c "set REACT_APP_API_URL=http://localhost:10000 && npx react-scripts start"
popd

echo.
echo === Done ===
echo   Backend: http://localhost:10000/health
echo   Frontend: http://localhost:3000
echo.
pause

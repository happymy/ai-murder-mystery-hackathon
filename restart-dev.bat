@echo off
chcp 65001 >nul
title AI Murder Mystery - Dev Server

echo === 按端口查找并关闭旧进程 ===
for /f "tokens=5" %%a in ('netstat -ano ^| find ":10000 " ^| find "LISTENING" 2^>nul') do (
    echo   结束端口 10000 进程 PID=%%a
    taskkill /f /pid %%a 2>nul
)
for /f "tokens=5" %%a in ('netstat -ano ^| find ":3000 " ^| find "LISTENING" 2^>nul') do (
    echo   结束端口 3000 进程 PID=%%a
    taskkill /f /pid %%a 2>nul
)
timeout /t 3 >nul

echo.
echo === 启动后端 (port 10000) ===
cd /d "%~dp0api"
start "Backend" cmd /c "pipenv run uvicorn main:app --host 0.0.0.0 --port 10000"
cd /d "%~dp0"

timeout /t 3 >nul

echo.
echo === 启动前端 (port 3000) ===
cd /d "%~dp0web"
start "Frontend" cmd /c "set REACT_APP_API_URL=http://localhost:10000 && npx react-scripts start"
cd /d "%~dp0"

echo.
echo === 完成 ===
echo   后端: http://localhost:10000/health
echo   前端: http://localhost:3000
echo.
pause

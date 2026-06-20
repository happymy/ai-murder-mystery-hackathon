# Restart dev servers (backend + frontend)

Write-Host "=== Kill old processes on ports 10000 and 3000 ===" -ForegroundColor Yellow
Get-NetTCPConnection -LocalPort 10000 -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  Killing port 10000 PID=$($_.OwningProcess)" -ForegroundColor Gray
    Stop-Process -Id $_.OwningProcess -Force
}
Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  Killing port 3000 PID=$($_.OwningProcess)" -ForegroundColor Gray
    Stop-Process -Id $_.OwningProcess -Force
}
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "=== Start Backend (port 10000) ===" -ForegroundColor Green
Push-Location "$PSScriptRoot\api"
Start-Process -NoNewWindow -FilePath "pipenv" -ArgumentList "run","uvicorn","main:app","--host","0.0.0.0","--port","10000"
Pop-Location

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "=== Start Frontend (port 3000) ===" -ForegroundColor Green
Push-Location "$PSScriptRoot\web"
$env:REACT_APP_API_URL = "http://localhost:10000"
Start-Process -NoNewWindow -FilePath "npx.cmd" -ArgumentList "react-scripts","start"
Pop-Location

Write-Host ""
Write-Host "=== Done ===" -ForegroundColor Green
Write-Host "  Backend: http://localhost:10000/health" -ForegroundColor Cyan
Write-Host "  Frontend: http://localhost:3000" -ForegroundColor Cyan

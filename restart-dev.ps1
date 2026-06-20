# 重启前后端开发服务器

Write-Host "=== 按端口查找并关闭旧进程 ===" -ForegroundColor Yellow
Get-NetTCPConnection -LocalPort 10000 -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  结束端口 10000 进程 PID=$($_.OwningProcess)" -ForegroundColor Gray
    Stop-Process -Id $_.OwningProcess -Force
}
Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  结束端口 3000 进程 PID=$($_.OwningProcess)" -ForegroundColor Gray
    Stop-Process -Id $_.OwningProcess -Force
}
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "=== 启动后端 (port 10000) ===" -ForegroundColor Green
Push-Location "$PSScriptRoot\api"
Start-Process -NoNewWindow -FilePath "pipenv" -ArgumentList "run","uvicorn","main:app","--host","0.0.0.0","--port","10000"
Pop-Location

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "=== 启动前端 (port 3000) ===" -ForegroundColor Green
Push-Location "$PSScriptRoot\web"
$env:REACT_APP_API_URL = "http://localhost:10000"
Start-Process -NoNewWindow -FilePath "npx.cmd" -ArgumentList "react-scripts","start"
Pop-Location

Write-Host ""
Write-Host "=== 完成 ===" -ForegroundColor Green
Write-Host "  后端: http://localhost:10000/health" -ForegroundColor Cyan
Write-Host "  前端: http://localhost:3000" -ForegroundColor Cyan

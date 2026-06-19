# 重启前后端开发服务器

Write-Host "=== 关闭旧进程 ===" -ForegroundColor Yellow
Get-Process -Name "uvicorn", "node", "python" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  结束进程: $($_.ProcessName) PID=$($_.Id)" -ForegroundColor Gray
    $_ | Stop-Process -Force
}
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "=== 启动后端 (port 10000) ===" -ForegroundColor Green
Push-Location "$PSScriptRoot\api"
$env:REACT_APP_API_URL = $null
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

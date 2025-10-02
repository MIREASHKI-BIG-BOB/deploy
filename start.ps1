# PowerShell скрипт для управления системой CTG (Windows)
# Аналог Makefile для Windows

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

function Show-Help {
    Write-Host "📋 Доступные команды:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  build    Собрать все Docker образы" -ForegroundColor Green
    Write-Host "  up       Запустить все сервисы" -ForegroundColor Green  
    Write-Host "  up-d     Запустить все сервисы в фоне" -ForegroundColor Green
    Write-Host "  down     Остановить все сервисы" -ForegroundColor Red
    Write-Host "  ps       Показать статус сервисов" -ForegroundColor Yellow
    Write-Host "  logs     Показать логи всех сервисов" -ForegroundColor Blue
    Write-Host "  restart  Перезапустить все сервисы" -ForegroundColor Magenta
    Write-Host "  clean    Остановить и удалить все" -ForegroundColor Red
    Write-Host "  rebuild  Пересобрать и перезапустить" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "💡 Использование: .\start.ps1 <команда>" -ForegroundColor Gray
    Write-Host "💡 Пример: .\start.ps1 build" -ForegroundColor Gray
}

function Build-Images {
    Write-Host "🔨 Сборка Docker образов..." -ForegroundColor Yellow
    docker compose -f deploy/docker-compose.yaml build
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Сборка завершена!" -ForegroundColor Green
    } else {
        Write-Host "Ошибка сборки!" -ForegroundColor Red
    }
}

function Start-Services {
    Write-Host "Запуск сервисов..." -ForegroundColor Yellow
    docker compose -f deploy/docker-compose.yaml up
}

function Start-ServicesDetached {
    Write-Host "Запуск сервисов в фоне..." -ForegroundColor Yellow
    docker compose -f deploy/docker-compose.yaml up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Сервисы запущены!" -ForegroundColor Green
        Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
        Write-Host "CTG: http://localhost:3000/ctg" -ForegroundColor Cyan
    }
}

function Stop-Services {
    Write-Host "Остановка сервисов..." -ForegroundColor Yellow
    docker compose -f deploy/docker-compose.yaml down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Сервисы остановлены!" -ForegroundColor Green
    }
}

function Show-Status {
    Write-Host "Статус сервисов:" -ForegroundColor Yellow
    docker compose -f deploy/docker-compose.yaml ps
}

function Show-Logs {
    Write-Host "Логи сервисов:" -ForegroundColor Yellow
    docker compose -f deploy/docker-compose.yaml logs -f
}

function Restart-Services {
    Write-Host "Перезапуск сервисов..." -ForegroundColor Yellow
    docker compose -f deploy/docker-compose.yaml restart
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Сервисы перезапущены!" -ForegroundColor Green
    }
}

function Clean-All {
    Write-Host "Очистка всех ресурсов..." -ForegroundColor Red
    docker compose -f deploy/docker-compose.yaml down -v
    docker system prune -f
    Write-Host "Очистка завершена!" -ForegroundColor Green
}

function Rebuild-All {
    Write-Host "Пересборка и перезапуск..." -ForegroundColor Cyan
    Stop-Services
    Build-Images
    Start-ServicesDetached
}

# Основная логика
switch ($Command.ToLower()) {
    "help" { Show-Help }
    "build" { Build-Images }
    "up" { Start-Services }
    "up-d" { Start-ServicesDetached }
    "down" { Stop-Services }
    "ps" { Show-Status }
    "logs" { Show-Logs }
    "restart" { Restart-Services }
    "clean" { Clean-All }
    "rebuild" { Rebuild-All }
    default {
        Write-Host "Неизвестная команда: $Command" -ForegroundColor Red
        Write-Host ""
        Show-Help
        exit 1
    }
}
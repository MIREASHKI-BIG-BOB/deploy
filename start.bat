@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

if "%1"=="" (
    call :show_help
    exit /b 0
)

if "%1"=="help" call :show_help
if "%1"=="build" call :build_images
if "%1"=="up" call :start_services
if "%1"=="up-d" call :start_services_detached
if "%1"=="down" call :stop_services
if "%1"=="ps" call :show_status
if "%1"=="logs" call :show_logs
if "%1"=="restart" call :restart_services
if "%1"=="clean" call :clean_all
if "%1"=="rebuild" call :rebuild_all

if not "%1"=="help" if not "%1"=="build" if not "%1"=="up" if not "%1"=="up-d" if not "%1"=="down" if not "%1"=="ps" if not "%1"=="logs" if not "%1"=="restart" if not "%1"=="clean" if not "%1"=="rebuild" (
    echo Неизвестная команда: %1
    echo.
    call :show_help
    exit /b 1
)
exit /b 0

:show_help
echo Доступные команды:
echo.
echo   build    Собрать все Docker образы
echo   up       Запустить все сервисы
echo   up-d     Запустить все сервисы в фоне
echo   down     Остановить все сервисы
echo   ps       Показать статус сервисов
echo   logs     Показать логи всех сервисов
echo   restart  Перезапустить все сервисы
echo   clean    Остановить и удалить все
echo   rebuild  Пересобрать и перезапустить
echo.
echo Использование: start.bat ^<команда^>
echo Пример: start.bat build
exit /b 0

:build_images
echo Сборка Docker образов...
docker compose -f deploy/docker-compose.yaml build
if !errorlevel! equ 0 (
    echo Сборка завершена!
) else (
    echo Ошибка сборки!
)
exit /b 0

:start_services
echo Запуск сервисов...
docker compose -f deploy/docker-compose.yaml up
exit /b 0

:start_services_detached
echo Запуск сервисов в фоне...
docker compose -f deploy/docker-compose.yaml up -d
if !errorlevel! equ 0 (
    echo Сервисы запущены!
    echo Frontend: http://localhost:3000
    echo CTG: http://localhost:3000/ctg
)
exit /b 0

:stop_services
echo Остановка сервисов...
docker compose -f deploy/docker-compose.yaml down
if !errorlevel! equ 0 (
    echo Сервисы остановлены!
)
exit /b 0

:show_status
echo Статус сервисов:
docker compose -f deploy/docker-compose.yaml ps
exit /b 0

:show_logs
echo Логи сервисов:
docker compose -f deploy/docker-compose.yaml logs -f
exit /b 0

:restart_services
echo Перезапуск сервисов...
docker compose -f deploy/docker-compose.yaml restart
if !errorlevel! equ 0 (
    echo Сервисы перезапущены!
)
exit /b 0

:clean_all
echo Очистка всех ресурсов...
docker compose -f deploy/docker-compose.yaml down -v
docker system prune -f
echo Очистка завершена!
exit /b 0

:rebuild_all
echo Пересборка и перезапуск...
call :stop_services
call :build_images
call :start_services_detached
exit /b 0
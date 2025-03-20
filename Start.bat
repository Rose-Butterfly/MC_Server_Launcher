@echo off
chcp 65001 >nul

:: 解析参数文件，跳过注释行（以 # 开头的行）
for /f "tokens=1,2 delims== skip=1" %%A in (startup_parameter.txt) do (
    if "%%A"=="RAMX" set RAMX=%%B
    if "%%A"=="RAMS" set RAMS=%%B
    if "%%A"=="WAIT_TIME" set WAIT_TIME=%%B
    if "%%A"=="CUSTOM_PARAMS" set CUSTOM_PARAMS=%%B
    if "%%A"=="JAR_FILE" set JAR_FILE=%%B
    if "%%A"=="JAVA_PATH" set JAVA_PATH=%%B
)

:: 检查 RAMX 和 RAMS 是否为空，增加条件判断的安全性
if "%RAMX%"=="" (

    echo [错误] RAMX 参数未设置！请检查 startup_parameter.txt。

    pause & exit)
if "%RAMS%"=="" (

    echo [错误] RAMS 参数未设置！请检查 startup_parameter.txt。

    pause & exit)
if "%WAIT_TIME%"=="" (set WAIT_TIME=3)
if "%CUSTOM_PARAMS%"=="" (set CUSTOM_PARAMS=)
if "%JAVA_PATH%"=="" (set JAVA_PATH=java)
if "%JAR_FILE%"=="" (

    echo [错误] JAR_FILE 参数未设置！请检查 startup_parameter.txt。

    pause & exit)

:: 获取系统最大可用内存
for /f "tokens=*" %%A in ('powershell -command "(Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory"') do set /a SYS_MAX_RAM=%%A / 1024

:: 打印服务器信息
echo ============================================

echo        欢迎使用 Minecraft 服务器启动器

echo --------------------------------------------

echo   分配最大内存 (RAMX) ：%RAMX%

echo   分配最小内存 (RAMS) ：%RAMS%

echo   最大可用内存   ：%SYS_MAX_RAM% MB

echo   崩溃重启等待时间：%WAIT_TIME% 秒

echo   其他启动参数   ：%CUSTOM_PARAMS%

echo   使用的 JAR 文件 ：%JAR_FILE%

echo ============================================

:: 等待用户确认
pause
:START

    echo [启动] 正在启动 Minecraft 服务器...
    
    "%JAVA_PATH%" -Xms%RAMS% -Xmx%RAMX% %CUSTOM_PARAMS% -jar %JAR_FILE% nogui

    echo [警告] 服务器意外崩溃！将在 %WAIT_TIME% 秒后重启...

    timeout /t %WAIT_TIME% /nobreak >nul
    goto START

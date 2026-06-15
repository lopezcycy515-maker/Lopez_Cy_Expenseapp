@echo off
setlocal
cd /d "%~dp0"

set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "GRADLE_USER_HOME=%~dp0.gradle-local"

echo.
echo [1/3] Stopping old Gradle builds...
cd android
call gradlew.bat --stop >nul 2>&1
cd ..

echo [2/3] Clearing stale lock files...
if exist "android\.gradle" rmdir /s /q "android\.gradle" 2>nul

echo [3/3] Building release APK (please wait 3-5 min)...
echo.
flutter build apk --release

if %ERRORLEVEL% neq 0 (
    echo.
    echo BUILD FAILED. Close other terminals/Android Studio, then run this again.
    exit /b 1
)

echo.
echo SUCCESS! Your APK is here:
echo %~dp0build\app\outputs\flutter-apk\app-release.apk
explorer.exe /select,"%~dp0build\app\outputs\flutter-apk\app-release.apk"

# Build release APK — stops stale Gradle locks first
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:GRADLE_USER_HOME = Join-Path $PSScriptRoot ".gradle-local"

Write-Host "[1/3] Stopping old Gradle builds..."
Push-Location android
& .\gradlew.bat --stop 2>$null
Pop-Location

Write-Host "[2/3] Clearing stale lock files..."
Remove-Item -Recurse -Force "android\.gradle" -ErrorAction SilentlyContinue

Write-Host "[3/3] Building release APK (please wait 3-5 min)..."
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    $apk = Join-Path $PSScriptRoot "build\app\outputs\flutter-apk\app-release.apk"
    Write-Host "`nSUCCESS! APK: $apk" -ForegroundColor Green
    explorer.exe "/select,$apk"
} else {
    Write-Host "`nBUILD FAILED. Close other terminals, then run build_apk.bat again." -ForegroundColor Red
    exit $LASTEXITCODE
}

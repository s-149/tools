@echo off
setlocal

:: --------------------------------------
:: 1. Set folder yang akan dipindai
:: --------------------------------------
set "tempFolder=%temp%"
set "systemTempFolder=C:\Windows\Temp"
set "downloadFolder=%userprofile%\Downloads"
set "prefetchFolder=C:\Windows\Prefetch"
set "logFile=C:\cleaningDiskLog.txt"

:: --------------------------------------
:: 2. Mulai pemindaian dan pembuatan log
:: --------------------------------------
echo Pemindaian file sampah dimulai... > "%logFile%"
echo Menutup aplikasi yang sedang berjalan... >> "%logFile%"
echo. >> "%logFile%"

:: Tutup aplikasi yang mungkin menggunakan file sementara
tasklist /FI "STATUS eq RUNNING" > "%temp%\tasklist.txt"
for /F "tokens=1" %%A in (%temp%\tasklist.txt) do (
    if /I "%%A"=="WINWORD.EXE" taskkill /F /IM WINWORD.EXE >> "%logFile%"
    if /I "%%A"=="EXCEL.EXE" taskkill /F /IM EXCEL.EXE >> "%logFile%"
    if /I "%%A"=="chrome.exe" taskkill /F /IM chrome.exe >> "%logFile%"
    if /I "%%A"=="firefox.exe" taskkill /F /IM firefox.exe >> "%logFile%"
)
echo Aplikasi yang tidak penting sudah ditutup. >> "%logFile%"
echo. >> "%logFile%"

:: --------------------------------------
:: 3. Pindai folder untuk file sementara/sampah
:: --------------------------------------

:: Folder %Temp%
echo Memindai folder Temp... >> "%logFile%"
dir /s "%tempFolder%" >> "%logFile%"

:: Folder %Temp%
echo Memindai folder Temp... >> "%logFile%"
dir /s "%systemTempFolder%" >> "%logFile%"

:: Folder Prefetch
echo Memindai folder Prefetch... >> "%logFile%"
dir /s "%prefetchFolder%" >> "%logFile%"

:: Recycle Bin
echo Memindai Recycle Bin... >> "%logFile%"
PowerShell -NoProfile -Command "Get-ChildItem -Path 'Recycle:\' -Force" >> "%logFile%"

:: --------------------------------------
:: 4. Menghapus file sementara/sampah dengan PowerShell
:: --------------------------------------

:: Hapus file sementara di folder %Temp%
echo Menghapus file di folder Temp...
PowerShell -Command "Remove-Item -Path '%tempFolder%\*' -Recurse -Force" 2>> "%logFile%"

:: Hapus file sementara di folder Temp
echo Menghapus file di folder Temp...
PowerShell -Command "Remove-Item -Path '%systemTempFolder%\*' -Recurse -Force" 2>> "%logFile%"

:: Hapus file di folder Prefetchs
echo Menghapus file di folder Prefetch...
PowerShell -Command "Remove-Item -Path '%prefetchFolder%\*' -Recurse -Force" 2>> "%logFile%"

:: Kosongkan Recycle Bin
echo Mengosongkan Recycle Bin...
PowerShell -NoProfile -Command Clear-RecycleBin -Force 2>> "%logFile%"

echo Pembersihan selesai. Log aktivitas tersimpan di %logFile%.
pause
endlocal

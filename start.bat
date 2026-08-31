@echo off
title All MediaTek Firmware Dump Kit - 100% Auto Installer
color 0A
cls

echo ============================================================
echo   All MediaTek Firmware Dump Kit - Avtomatik Sozlash
echo ============================================================
echo.

:: 1. Admin huquqini tekshirish
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [OGOHLANTIRISH] Drayverlar uchun Administrator huquqi kerak!
    echo Iltimos, start.bat faylini "Run as Administrator" qilib oching.
    echo.
    pause
    exit /b
)

:: 2. Python'ni avtomatik aniqlash va o'rnatish
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Python topilmadi. Avtomatik yuklab o'rnatish boshlanmoqda...
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe' -OutFile 'python_installer.exe'"
    
    echo Python 3.11 o'rnatilmoqda...
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    del python_installer.exe
    
    set "PATH=C:\Program Files\Python311;C:\Program Files\Python311\Scripts;%PATH%"
    echo [OK] Python muvaffaqiyatli o'rnatildi!
) else (
    echo [OK] Python tizimda mavjud.
)

:: 3. Python kutubxonalarini to'liq o'rnatish
echo.
echo [1/3] Pip va zarur kutubxonalar o'rnatilmoqda...
python -m pip install --upgrade pip >nul 2>&1
pip install -r mtkclient/requirements.txt
pip install pyusb libusb pycryptodome pywin32

:: 4. Arxiv fayllar bo'lsa, ularni avtomatik ochish (.zip)
echo.
echo [2/3] Drayver va zaruriy arxivlar o'rganilmoqda...
for %%f in (Drivers\*.zip) do (
    echo Unpacking %%f ...
    powershell -Command "Expand-Archive -Path '%%f' -DestinationPath 'Drivers' -Force"
)

:: 5. Drayverlarni ekranda ko'rsatib o'rnatish
echo.
echo ============================================================
echo MTK, UsbDk va LibUSB drayverlari o'rnatilmoqda...
echo ============================================================
echo.

if exist "Drivers\dpinst-amd64.exe" (
    echo [1/3] MTK VCOM drayveri o'rnatilmoqda...
    start /wait Drivers\dpinst-amd64.exe /c
)

if exist "Drivers\UsbDk_1.0.22_x64.msi" (
    echo [2/3] UsbDk utilitasi o'rnatilmoqda...
    msiexec /i "Drivers\UsbDk_1.0.22_x64.msi" /qb
)

if exist "Drivers\libusb-win32-devel-filter-1.2.6.0.exe" (
    echo [3/3] LibUSB Filter drayveri o'rnatilmoqda...
    start /wait Drivers\libusb-win32-devel-filter-1.2.6.0.exe
)

:: 6. mtkclient GUI'ni ishga tushirish
echo.
echo ============================================================
echo [3/3] Barcha jarayon yakunlandi! MTK GUI ishga tushmoqda...
echo Qurilmani o'chiring, Vol+ va Vol- tugmalarini bosib ulang.
echo ============================================================
echo.

cd mtkclient
python mtk gui

pause

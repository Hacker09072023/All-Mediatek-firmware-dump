@echo off
title MTKClient Auto-Dump Utility
cd /d "%~dp0mtkclient"

echo Python kutubxonalari o'rnatilmoqda...
python -m pip install -r requirements.txt >nul 2>&1

echo.
echo ========================================================
echo  MTK AUTO-DUMP JAZAYONI TAYYOR
echo ========================================================
echo.
echo 1. Telefonni TO'LIQ o'chiring.
echo 2. Ovoz (+) va Ovoz (-) tugmalarini bir vaqtda bosib turing.
echo 3. USB kabelni kompyuterga ulang.
echo.
echo Telefon ulanganidan so'ng DUMP avtomatik boshlanadi...
echo.

python mtk rl --skip userdata ..\DUMP_OUT

echo.
echo ========================================================
echo  DUMP TUGADI! Fayllar "DUMP_OUT" papkasida saqlandi.
echo ========================================================
pause

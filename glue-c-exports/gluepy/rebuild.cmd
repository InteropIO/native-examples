@echo off
pyinstaller --onefile gluepy-demo.py && copy /Y dist\gluepy-demo.exe .
echo Done
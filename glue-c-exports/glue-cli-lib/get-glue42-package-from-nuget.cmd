@echo off
echo Downloading Glue42 .NET package
curl "https://globalcdn.nuget.org/packages/glue42.2018.2202.0.nupkg" --output "./glue42.nupkg"
echo Unpacking Glue42 .NET package
tar -xf glue42.nupkg lib/net45/
move /Y lib\net45\* . > nul
del *.nupkg > nul
rd /S /Q lib
echo Done
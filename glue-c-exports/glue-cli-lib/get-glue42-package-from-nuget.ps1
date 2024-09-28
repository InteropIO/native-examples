$curdir = (Get-Item .).FullName;
"Cur dir is " + $curdir
"Downloading io.Connect.NET package"
(new-object System.Net.WebClient).DownloadFile("https://www.nuget.org/api/v2/package/io.Connect.NET/1.22.0",$curdir + "\io.Connect.NET.nupkg")
"Downloading glue-cli-lib package"
(new-object System.Net.WebClient).DownloadFile("https://globalcdn.nuget.org/packages/glue-cli-lib.1.5.0.nupkg?packageVersion=1.5.0", $curdir + "\glue-cli-lib.nupkg")
"Unpacking io.Connect.NET package"
tar -xf io.Connect.NET.nupkg lib/net45/
"Unpacking glue-cli-lib package"
tar -xf glue-cli-lib.nupkg glue-cli-lib
"Updating local copies"
cmd /C "rd /S /Q 32bit"
cmd /C "move /Y glue-cli-lib\32bit . > nul"
cmd /C "move /Y glue-cli-lib\*.dll . > nul"
cmd /C "move /Y glue-cli-lib\*.pdb . > nul"
cmd /C "move /Y glue-cli-lib\*.lib . > nul"
cmd /C "move /Y glue-cli-lib\*.h . > nul"
cmd /C "move /Y lib\net45\* . > nul"

"Cleaning up"
cmd /C "del *.nupkg > nul"
cmd /C "rd /S /Q lib"
cmd /C "rd /S /Q glue-cli-lib"
"Downloading Glue42 .NET package"
(new-object System.Net.WebClient).DownloadFile("https://www.nuget.org/api/v2/package/Glue42/2018.2231.0","./glue42.nupkg")
"Unpacking Glue42 .NET package"
tar -xf glue42.nupkg lib/net45/
cmd /C "move /Y lib\net45\* . > nul"
cmd /C "del *.nupkg > nul"
cmd /C "rd /S /Q lib"
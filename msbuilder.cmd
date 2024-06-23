if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    for /f "usebackq delims=" %%i in (`call "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -prerelease -latest -find VC\Auxiliary\Build\vcvarsall.bat`) do (
        call "%%i" x86
    )
)

call msbuild VersionControl.sln /t:Clean /p:Configuration=Release /p:Platform=Win32 /p:UseEnv=true %*

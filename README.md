![Support](https://img.shields.io/badge/Support-Community-yellow.svg)

# Unity Plugin for Helix Core

## Overview

This is the Helix Core (Perforce) version control plugin for [Unity](http://www.unity3d.com). It is based on the [source code published by Unity](https://github.com/Unity-Technologies/NativeVersionControlPlugins), but allows the linked version of the P4 API to be changed as needed.

Even though the feature set is unchanged from upstream, recent versions of the P4 API have better support for TLS, including newer features like SNI, and have numerous bugfixes and performance improvements that may give you a better experience when interacting with your Helix Core server.

Version control plugins are part of the Unity installation. Unity scans a known `VersionControl` directory and executes every binary in it. It communicates with the plugins using pipes, so the plugin binaries are just regular programs that implement a particular protocol.

## Runtime Requirements

* Unity 4.2+

## Documentation

You can either [download and extract a prebuilt plugin binary](https://github.com/perforce/unity-p4-plugin/releases) or [build a copy yourself](#build). Either way, you will end up with a single executable, called either `PerforcePlugin.exe` or `PerforcePlugin`.

To install it, you need to overwrite the file with the same name that is bundled with your Unity installation. For example, if you installed Unity 2022.3.34f1 using Unity Hub, the file would be located at:

* **Windows:** `C:\Program Files\Unity\Hub\Editor\2022.3.34f1\Editor\Data\Tools\VersionControl\PerforcePlugin.exe`
* **macOS:** `/Applications/Unity/Hub/Editor/2022.3.34f1/Unity.app/Contents/Tools/VersionControl/PerforcePlugin`
* **Linux:** `~/Unity/Hub/Editor/2022.3.34f1/Editor/Data/Tools/VersionControl/PerforcePlugin`

Once you've replaced the file, restart Unity and follow their [version control integration instructions](https://docs.unity3d.com/2022.3/Documentation/Manual/Versioncontrolintegration.html) to configure a connection to a Helix Core server.

## Support

This project is a community supported project and is not officially supported by Perforce. Pull requests and issues are the responsibility of the project's moderator(s); this may be a vetted individual or team with members outside of the Perforce organization. Perforce does not officially support these projects, therefore all issues should be reported and managed via GitHub (not via Perforce's standard support process).

## Build

Plugin binaries for recent P4 API versions are built by GitHub Actions and made available as GitHub releases. These should be sufficient for most use cases, but it is also possible to build your own copy of the plugin.

### Build Requirements

* [OpenSSL 1.1.0+](https://www.openssl.org/source/) (static libraries)
* [Helix Core API for C/C++](https://www.perforce.com/downloads/helix-core-c/c-api) (static libraries compatible with selected OpenSSL version)

The macOS build is for 64-bit Intel; ARM libraries are not supported.

To run the integration test suite, you also need:

* [Helix Core Server](https://www.perforce.com/downloads/helix-core-p4d) (P4D)
* [Helix Command-line Client](https://www.perforce.com/downloads/helix-command-line-client-p4) (P4)

### Windows

This build process requires Visual Studio 2022 and Perl ([Strawberry Perl](https://strawberryperl.com/) is a good choice for Windows).

For most configurations you can probably use the `build.pl` Perl script on Windows. This detects the location of `msbuild` and the MSVC++ toolchain and uses it to build the plugin and the test driver.

```powershell
PS> $env:INCLUDE += ";C:\path\to\p4api\include\p4\"
PS> $env:LIB += ";C:\path\to\p4api\lib\;C:\path\to\openssl\lib\"
PS> perl build.pl
```

In more complex cases, you can invoke `msbuild` directly. You need to set up your environment correctly for MSVC++, e.g. using `vsvars32.bat`.

```powershell
PS> msbuild VersionControl.sln /t:Clean /t:P4Plugin /t:TestServer /p:Configuration=Release /p:Platform=Win32 /p:UseEnv=true
```

To run the integration tests, you also need copies of `p4d.exe` and `p4.exe`. These must be placed in a directory called `PerforceBinaries\Win32` relative to this repository's root. Then run:

```powershell
PS> perl build.pl -test
```

### Linux and macOS

You'll need GCC, GNU Make, and Perl 5 to build the plugin. Linux also requires GTK+ 3 (development headers and libraries). For macOS, everything you need is in the Xcode Command Line Tools.

The `build.pl` Perl script is usually sufficient to invoke the right components of the respective makefiles to build the plugin binaries.

If you've placed the P4 API or OpenSSL header files and static libraries in locations that are not already on your include path and library path respectively, you need to set the environment correctly first.

```console
$ export CFLAGS="-I/path/to/p4api/include/p4"
$ export LDLIBS="-L/path/to/p4api/lib -L/path/to/openssl/lib"
$ perl build.pl
```

On macOS, you should make sure your library path _does not_ contain the `dylib` counterparts to the P4 API or OpenSSL static libraries. The macOS linker will always prefer dynamic libraries to static libraries, which will probably cause your end users to be frustrated when they try to use the plugin.

The plugin and test driver binaries will be placed in the `Build/linux64` or `Build/OSXx64` directory.

To run the integration tests, you also need copies of `p4d` and `p4`. For example:

```console
$ mkdir -p PerforceBinaries/linux64
$ curl -fsSL -o PerforceBinaries/linux64/p4d 'https://ftp.perforce.com/perforce/r24.1/bin.linux26x86_64/p4d'
$ curl -fsSL -o PerforceBinaries/linux64/p4 'https://ftp.perforce.com/perforce/r24.1/bin.linux26x86_64/p4'
```

Or:

```console
$ mkdir -p PerforceBinaries/OSX
$ curl -sSL -o PerforceBinaries/OSX/p4d 'https://ftp.perforce.com/perforce/r24.1/bin.macosx12arm64/p4d'
$ curl -sSL -o PerforceBinaries/OSX/p4 'https://ftp.perforce.com/perforce/r24.1/bin.macosx12arm64/p4'
```

Then run:

```console
$ chmod +x PerforceBinaries/*/*
$ perl build.pl -test
```

## License

The original source code created by Unity was dedicated to the public domain. This distribution is released under the terms of the New BSD License. See the [LICENSE](LICENSE.txt) file for additional information.

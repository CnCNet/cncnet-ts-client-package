# build-installer

Builds the Inno Setup installer for the CnCNet Tiberian Sun client package.

Based on the CnCNet Yuri's Revenge build-installer (`cncnet-yr-client-package/tools/build-installer`),
with features ported from the legacy `ts-client-installer`:

- Tiberian Sun wizard theming (`libs/ISTheme`, `inno/Resources/TiberianSun*Background.bmp`)
- Copying movies from an existing TS install (registry + Steam detection, `TSunmix` decryption)
- Downloading movies / the restored-movies archive before install with a real
  per-file progress bar and a Stop button (`TDownloadWizardPage` in the
  `[Code]` section, the same page type `InnoDependencyInstaller` uses for its
  dependency downloads), then installing / extracting natively (Inno Setup 7
  `extractarchive` support - no InnoDownloadPlugin / 7zip DLLs needed)
- .NET Framework 4.8 / .NET 8 Desktop Runtime / XNA 4.0 Refresh /
  VC++ 2010 SP1 (x86) / DirectX 9 runtime installation at install time
  (`libs/InnoDependencyInstaller` git submodule, pinned at `b73d3a9`;
  machine-wide, so only installed for all-users installs - per-user installs
  get an "elevate now" prompt on the ready page). Only the legacy XNA renderer
  needs the XNA/VC++/DirectX parts - the OpenGL and DirectX renderers are
  fully managed (MonoGame/SharpDX). The XNA renderer's audio engine
  (`X3DAudio1_7.dll`) is provided machine-wide by the XNA 4.0 Refresh
  redist; that DLL is deliberately **not** bundled with the package (a
  per-user install missing the redist is surfaced by the
  missing-dependencies dialogs instead). The XNA redist is
  registered in `installer.twig` (not the library, which is a clean
  submodule) via `Dependency_AddIfMissing` + the local
  `IsXNA40Installed()` check.

## Prerequisites

- Windows (ISCC.exe is bundled in `inno/bin`)
- Node.js >= 20.11 (for the template build)

Everything else (Inno Setup 7, the Inno libraries, theme assets, TSunmix)
is bundled in this directory - no external fetches at build time. The
`InnoDependencyInstaller` library is a git submodule (the only one): run
`git submodule update --init` if its directory is empty.

## Building

```bat
installer.bat
```

or:

```bat
cd tools\build-installer
npm ci
npm run build-installer
```

The build:

1. Verifies the required files: `version` (git-ignored - generate it with `VersionWriter.exe`, see `versionconfig.ini`), `preupdateexec`/`updateexec`, the Inno libraries, the wizard assets and `ISCC.exe`.
2. Builds `MIX\*.mix` from `MixSource\` when missing (via `Tools\BuildMixes.ps1`).
3. Renders `inno/installer.iss` from `inno/installer.twig`.
4. Compiles with `inno/bin/ISCC.exe` into `installer-output\CnCNet_TiberianSun_Installer.exe`.

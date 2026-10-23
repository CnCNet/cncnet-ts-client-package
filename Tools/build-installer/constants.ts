import path from "path";
import fs from "node:fs";
import ini from "js-ini";

const packagePath = path.resolve(import.meta.dirname, "..", "..");
const buildInstallerPath = import.meta.dirname;
const innoPath = path.join(buildInstallerPath, "inno");

const versionFilePath = path.join(packagePath, "version");

function getAppVersion(): string {
    if (!fs.existsSync(versionFilePath)) {
        throw new Error(
            `Version file not found at: ${versionFilePath}\n` +
            "Generate it first (e.g. with VersionWriter.exe and versionconfig.ini)."
        );
    }

    const versionIni = ini.parse(fs.readFileSync(versionFilePath, "utf8"));

    if (versionIni.DTA?.Version) {
        return String(versionIni.DTA.Version);
    }

    throw new Error(
        `Invalid version file format, missing [DTA] Version. File: ${versionFilePath}`
    );
}

const appVersion = getAppVersion();

const app = {
    name: "CnCNet Tiberian Sun",
    version: appVersion,
    versionName: `CnCNet Tiberian Sun ${appVersion}`,
    description: "Modern way of playing Tiberian Sun",
    publisher: "cncnet.org",
    publisherUrl: "https://cncnet.org/",
    supportUrl: "https://cncnet.org/forums/forum/cncnet-tiberian-sun/",
    updatesUrl: "https://cncnet.org/forums/forum/cncnet-tiberian-sun/",
    // Stored without braces: Inno 7 requires doubled braces for the literal
    // AppId value, so the template renders {{...}} around it.
    appId: "A1BB49D0-F44E-48F5-966E-CE2DE5DFAC43",
};

const sourceDir = packagePath;
const outputDir = path.join(packagePath, "installer-output");

// CnCNet movie downloads. Kept out of the .twig because Inno's {#Name}
// constant syntax conflicts with Twig comments.
// sizeKB is the file size in kilobytes (Inno Setup ExternalSize), used for
// an accurate download progress display.
const movies = [
    {
        file: "Movies01.mix",
        url: "https://downloads.cncnet.org/updates/games/ts/updates/Components/Movies01.mix",
        sizeKB: 484415
    },
    {
        file: "Movies02.mix",
        url: "https://downloads.cncnet.org/updates/games/ts/updates/Components/Movies02.mix",
        sizeKB: 479157
    },
    {
        file: "Movies03.mix",
        url: "https://downloads.cncnet.org/updates/games/ts/updates/Components/Movies03.mix",
        sizeKB: 479691
    }
];

// Restored-movies archive, downloaded and extracted natively when the user
// chooses to reuse the movies from an existing Tiberian Sun install (saves
// ~1.4 GB of downloads; the originals are then copied, decrypted and mixed
// in place).
const extraMovies = {
    file: "Expand00.7z",
    url: "https://downloads.cncnet.org/tsclient/Expand00.7z",
    sizeKB: 52964
};
const setupIconPath = path.join(innoPath, "Resources", "tsicon.ico");
const licenseFilePath = path.join(innoPath, "Resources", "License-TiberianSun.txt");
const outputBaseFilename = "CnCNet_TiberianSun_Installer";

// Files and directories that exist in the client package but must not be
// shipped to the end user (dev tooling, build inputs, generated/runtime files).
const excludedInstallerFiles = [
    ".git*",
    ".git\\*",
    ".github\\*",
    "AGENTS.md",
    "MEMORY.md",
    "README.md",
    "Game.pdb",
    "BuildMixes.bat",
    "Tools\\*",
    "MixSource\\*",
    "cache\\*",
    "QM\\*",
    "Client\\*",
    "VersionWriter-CopiedFiles\\*",
    "MainMenuTheme.bak",
    "preupdateexec",
    "updateexec",
    "versionconfig.ini",
    "version_u",
    "version_cc",
    "ddraw.dll",
    "ddraw.ini",
    "sun.ini",
    "SUN.ini",
    "KEYBOARD.INI",
    "spawn.ini",
    "spawnmap.ini",
    "spawnSG.ini",
    "stats.dmp",
    "ts.log",
    "TS.log",
    "except.txt",
    "mpstats.log",
    "mpstats.txt",
    "sync*.txt",
    "_gsdata_",
    "buffer",
    "HALLFAME.DAT",
    "SAVEGAME.NET",
    "Saved Games\\*.SAV",
    "tools\\*",
    "installer-output\\*",
    ".vscode\\*"
];

export {
    packagePath,
    buildInstallerPath,
    innoPath,
    versionFilePath,
    app,
    sourceDir,
    outputDir,
    setupIconPath,
    licenseFilePath,
    outputBaseFilename,
    movies,
    extraMovies,
    excludedInstallerFiles
};

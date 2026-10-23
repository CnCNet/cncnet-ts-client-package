import fs from "node:fs";
import path from "node:path";
import { spawn, execFileSync } from "node:child_process";
import { TemplateModel } from "../class/template-model.class";
import {
    packagePath,
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
} from "../constants";

const requiredFiles = [
    versionFilePath,
    path.join(packagePath, "preupdateexec"),
    path.join(packagePath, "updateexec"),
    path.join(packagePath, "versionconfig.ini"),
    path.join(innoPath, "libs", "InnoDependencyInstaller", "CodeDependencies.iss"),
    path.join(innoPath, "libs", "ISTheme", "ISTheme.iss"),
    path.join(innoPath, "libs", "TSunmix", "tsunmix.exe"),
    path.join(innoPath, "Resources", "tsicon.ico"),
    path.join(innoPath, "Resources", "License-TiberianSun.txt"),
    path.join(innoPath, "Resources", "TiberianSunWizardFormBackground.bmp"),
    path.join(innoPath, "Resources", "TiberianSunInnerPageBackground.bmp"),
    path.join(innoPath, "Resources", "TiberianSunPageBackground.bmp"),
    path.join(innoPath, "Resources", "WritePermissionTestFile.txt"),
    path.join(innoPath, "bin", "ISCC.exe")
];

async function checkForRequiredFilesAsync(): Promise<void> {
    console.log(`Checking for required files in ${sourceDir}...`);

    for (const filePath of requiredFiles) {
        if (!fs.existsSync(filePath)) {
            throw new Error(`Required file not found: ${filePath}`);
        }
    }

    console.log(`All required files found.`);
}

// preupdateexec/updateexec are INI-like but their Delete sections contain
// bare path lines (no key=value), which generic INI parsers reject, so they
// are parsed manually. [Rename] entries are key=value and are ignored here
// (they are applied at update time, not install time).
function getInstallDeleteFiles(): string[] {
    console.log("Extracting install delete files from preupdateexec and updateexec...");

    const dataSections = [
        "Delete",
        "DeleteFolder",
        "DeleteFolderIfEmpty",
        "ForceDeleteFolder"
    ];
    const files: string[] = [];

    for (const file of ["preupdateexec", "updateexec"]) {
        const filePath = path.join(packagePath, file);
        const lines = fs.readFileSync(filePath, "utf8").split(/\r?\n/);

        let section = "";
        for (const rawLine of lines) {
            const line = rawLine.trim();

            if (line.length === 0 || line.startsWith(";")) {
                continue;
            }

            if (line.startsWith("[") && line.endsWith("]")) {
                section = line.slice(1, -1).trim();
                continue;
            }

            if (dataSections.includes(section)) {
                const entry = line.split("=")[0].trim();
                if (entry.length > 0) {
                    files.push(entry);
                }
            }
        }
    }

    const uniqueFiles = [...new Set(files)];
    console.log(`Found ${uniqueFiles.length} install delete files.`);
    return uniqueFiles;
}

function buildMixes(): void {
    // The installer ships MIX\*.mix archives built from MixSource\ by
    // Tools\BuildMixes.ps1 (BuildMixes.bat is its Windows wrapper). Skip the
    // build when the archives already exist.
    const mixDir = path.join(packagePath, "MIX");
    const mixFiles = fs.existsSync(mixDir)
        ? fs.readdirSync(mixDir).filter((f) => f.toLowerCase().endsWith(".mix"))
        : [];

    if (mixFiles.length > 0) {
        console.log(
            `MIX archives already present (${mixFiles.length}), skipping MIX build.`
        );
        return;
    }

    if (process.platform !== "win32") {
        throw new Error(
            "MIX\\*.mix archives are missing and BuildMixes.ps1 requires Windows.\n" +
            "Run BuildMixes.bat on Windows before building the installer."
        );
    }

    console.log("Building MIX archives from MixSource (BuildMixes.ps1)...");
    execFileSync(
        "powershell.exe",
        [
            "-NoLogo",
            "-NoProfile",
            "-ExecutionPolicy",
            "Bypass",
            "-File",
            path.join(packagePath, "Tools", "BuildMixes.ps1")
        ],
        { cwd: packagePath, stdio: "inherit" }
    );

    if (!fs.existsSync(mixDir) || fs.readdirSync(mixDir).length === 0) {
        throw new Error("MIX build finished but no MIX archives were produced.");
    }
}

async function buildInstallerTemplateAsync(): Promise<void> {
    console.log(`Building installer template in ${innoPath}...`);

    const templateModel = new TemplateModel({
        app,
        sourceDir,
        outputDir,
        setupIconFile: setupIconPath,
        licenseFile: licenseFilePath,
        outputBaseFilename,
        installDeleteFiles: getInstallDeleteFiles(),
        excludedInstallerFiles,
        movies,
        extraMovies,
        innoPath
    });

    const twig = (await import("twig")).default;

    await new Promise<void>((resolve, reject) => {
        twig.renderFile(
            path.join(innoPath, "installer.twig"),
            templateModel,
            (err: Error | null, content: string) => {
                if (err) {
                    reject(err);
                    return;
                }

                fs.writeFileSync(path.join(innoPath, "installer.iss"), content, {
                    encoding: "utf8"
                });
                resolve();
            }
        );
    });
}

async function buildInstaller(): Promise<void> {
    await checkForRequiredFilesAsync();
    buildMixes();
    await buildInstallerTemplateAsync();

    console.log("Compiling installer with Inno Setup...");

    return new Promise((resolve, reject) => {
        const iscc = path.join(innoPath, "bin", "ISCC.exe");
        const child = spawn(iscc, [path.join(innoPath, "installer.iss")], {
            cwd: innoPath,
            stdio: "inherit"
        });

        child.on("close", (code) => {
            if (code === 0) {
                console.log("Installer build completed successfully.");
                resolve();
            } else {
                reject(new Error(`ISCC exited with code ${code}`));
            }
        });

        child.on("error", (err) => {
            reject(new Error(`Failed to run ISCC: ${err.message}`));
        });
    });
}

export { buildInstaller };

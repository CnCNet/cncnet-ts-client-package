import { TemplateAppModel } from "./template-app-model.class";

export class TemplateModel {
    app: TemplateAppModel;
    sourceDir: string;
    outputDir: string;
    setupIconFile: string;
    licenseFile: string;
    outputBaseFilename: string;
    installDeleteFiles: string[];
    excludedInstallerFiles: string[];
    movies: any[];
    extraMovies: any;
    innoPath: string;

    constructor(templateData: any) {
        this.app = new TemplateAppModel(templateData.app);
        this.sourceDir = templateData.sourceDir;
        this.innoPath = templateData.innoPath;
        this.outputDir = templateData.outputDir;
        this.setupIconFile = templateData.setupIconFile;
        this.licenseFile = templateData.licenseFile;
        this.outputBaseFilename = templateData.outputBaseFilename;
        this.installDeleteFiles = templateData.installDeleteFiles;
        this.excludedInstallerFiles = templateData.excludedInstallerFiles;
        this.movies = templateData.movies;
        this.extraMovies = templateData.extraMovies;
    }
}

export class TemplateAppModel {
    name: string;
    version: string;
    versionName: string;
    description: string;
    publisher: string;
    publisherUrl: string;
    supportUrl: string;
    updatesUrl: string;
    appId: string;

    constructor(app: any) {
        this.name = app.name;
        this.version = app.version;
        this.versionName = app.versionName;
        this.description = app.description;
        this.publisher = app.publisher;
        this.publisherUrl = app.publisherUrl;
        this.supportUrl = app.supportUrl;
        this.updatesUrl = app.updatesUrl;
        this.appId = app.appId;
    }
}

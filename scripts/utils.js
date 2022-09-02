"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.runCheckOverChangedSpecFiles = exports.logWarn = exports.logError = exports.logToAzureDevops = void 0;
const avocado_1 = require("@azure/avocado");
exports.logToAzureDevops = (msg, type) => {
    const lines = msg.split('\n');
    for (const line of lines) {
        console.log(`##vso[task.logissue type=${type}]${line}`);
    }
};
exports.logError = (msg) => exports.logToAzureDevops(msg, 'error');
exports.logWarn = (msg) => exports.logToAzureDevops(msg, 'warning');
const internalCheck = async (checkOptions) => {
    const exec = async (commandLine, options = {}) => {
        console.log(commandLine);
        let result = {};
        try {
            result = await avocado_1.childProcess.exec(commandLine, options);
        }
        catch (e) {
            result = e;
        }
        if (!result.code) {
            return 0;
        }
        await checkOptions.onExecError(result);
        return result.code;
    };
    const context = { exec };
    const config = avocado_1.cli.defaultConfig();
    const pr = await avocado_1.devOps.createPullRequestProperties(config);
    if (pr === undefined) {
        return checkOptions.onNotInCI(context);
    }
    const changedJsonFiles = (await pr.diff())
        .filter(change => change.kind !== 'Deleted')
        .map(change => change.path)
        .filter(filePath => filePath.endsWith('.json') && filePath.startsWith('specification/'));
    if (changedJsonFiles.length === 0) {
        exports.logWarn("No changed spec json file");
        return;
    }
    let retCode = 0;
    for (const jsonFile of changedJsonFiles) {
        const code = await checkOptions.onCheckFile(context, jsonFile);
        if (code !== 0) {
            retCode = code;
        }
    }
    if (retCode !== 0) {
        await checkOptions.onFinalFailed(context);
    }
    process.exit(retCode);
};
exports.runCheckOverChangedSpecFiles = (options) => {
    internalCheck(options).catch(e => {
        console.error(e);
        exports.logError(`Fatal Error. Please report to adxsr@microsoft.com`);
        process.exit(-1);
    });
};
//# sourceMappingURL=utils.js.map
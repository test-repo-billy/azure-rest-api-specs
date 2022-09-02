"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("./utils");
utils_1.runCheckOverChangedSpecFiles({
    onCheckFile: (context, filePath) => {
        return context.exec(`prettier -c ${filePath}`);
    },
    onExecError: async (result) => {
        if (result.stdout) {
            console.log(result.stdout);
        }
    },
    onNotInCI: (context) => {
        utils_1.logWarn("Not in CI environment. Run against all the spec json.");
        return context.exec(`prettier -c "specification/**/*.json"`);
    },
    onFinalFailed: async () => {
        utils_1.logError('Code style issues found in the above file(s). Please follow https://aka.ms/AA6h31t to fix the issue.');
    }
});
//# sourceMappingURL=prettier-check.js.map
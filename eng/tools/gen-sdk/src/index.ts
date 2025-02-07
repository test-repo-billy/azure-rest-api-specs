/* eslint-disable @typescript-eslint/restrict-template-expressions */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable unicorn/prefer-ternary */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { exit } from "node:process";
import {
  findReadmeFiles,
  getArgumentValue,
  runSpecGenSdkCommand,
  getAllTypeSpecPaths,
} from "./utils.js";
import { LogLevel, logMessage } from "./logging.js";

export async function main() {
  // Get the arguments passed to the script
  const args: string[] = process.argv.slice(2);
  const runMode: string = getArgumentValue(args, "--rm", "");
  let statusCode = 0;
  if (runMode) {
    statusCode = await generateSdkForAllSpecs(runMode);
  }
  exit(statusCode);
}

/**
 * Generate SDKs for all specs.
 */
export async function generateSdkForAllSpecs(runMode: string): Promise<number> {
  const __filename: string = fileURLToPath(import.meta.url);
  const __dirname: string = path.dirname(__filename);
  let statusCode = 0;

  // Get the arguments passed to the script
  const args: string[] = process.argv.slice(2);
  const specRepoPath: string = path.resolve(
    getArgumentValue(args, "--scp", path.join(__dirname, "..", ".."))
  );
  const sdkLanguage: string = getArgumentValue(args, "--lang", "azure-sdk-for-net");
  const sdkRepoPath: string = path.resolve(
    getArgumentValue(args, "--sdp", path.join(specRepoPath, "..", sdkLanguage))
  );
  const workingFolder: string = path.resolve(
    getArgumentValue(args, "--wf", path.join(specRepoPath, ".."))
  );
  const triggerByPipeline: string = getArgumentValue(args, "--tr", "false");
  const specRepoCommit: string = getArgumentValue(args, "--commit", "HEAD");

  // Get the spec paths based on the run mode
  const specConfigPaths = getSpecPaths(runMode, specRepoPath);

  // Prepare markdown content
  let markdownContent = "\n";
  let failedContent = `## Specs Failed in Generation\n`;
  let succeededContent = `## Specs Succeeded in Generation\n`;
  let failedCount = 0;

  // Generate SDKs for each spec
  for (const specConfigPath of specConfigPaths) {
    logMessage(`Generating SDK from ${specConfigPath}`, LogLevel.Group);

    // Construct the spec-gen-sdk command
    const specGenSdkCommand = [];
    specGenSdkCommand.push(
      "spec-gen-sdk",
      "--scp",
      specRepoPath,
      "--sdp",
      sdkRepoPath,
      "--wf",
      workingFolder,
      "-l",
      sdkLanguage,
      "-c",
      specRepoCommit,
      "-t",
      triggerByPipeline
    );

    if (specConfigPath.endsWith("tspconfig.yaml")) {
      specGenSdkCommand.push("--tsp-config-relative-path", specConfigPath);
    } else {
      specGenSdkCommand.push("--readme-relative-path", specConfigPath);
    }
    logMessage(`Command:${specGenSdkCommand.join(" ")}`);
    try {
      await runSpecGenSdkCommand(specGenSdkCommand);
      logMessage("Command executed successfully");
    } catch (error) {
      logMessage(`Error executing command:${error}`, LogLevel.Error);
      statusCode = 1;
    }

    // Read the execution report to determine if the generation was successful
    const executionReportPath = path.join(workingFolder, `${sdkLanguage}_tmp/executionReport.json`);
    try {
      const executionReport = JSON.parse(fs.readFileSync(executionReportPath, "utf8"));
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      const executionResult = executionReport.packages[0]?.result;
      logMessage(`Execution Result:${executionResult}`);

      if (executionResult === "failed") {
        failedContent += `${specConfigPath},`;
        failedCount++;
      } else {
        succeededContent += `${specConfigPath},`;
      }
    } catch (error) {
      logMessage(
        `Error reading execution report at ${executionReportPath}:${error}`,
        LogLevel.Error
      );
      statusCode = 1;
    }
    logMessage("ending group logging", LogLevel.EndGroup);
  }
  if (failedCount > 0) {
    markdownContent += `${failedContent}\n`;
  }
  if (specConfigPaths.length > failedCount) {
    markdownContent += `${succeededContent}\n`;
  }
  markdownContent += `## Total Specs Failed:\n ${failedCount}\n`;
  markdownContent += `## Total Specs Generated:\n ${specConfigPaths.length}\n\n`;

  // Write the markdown content to a file
  const markdownFilePath = path.join(workingFolder, "out/logs/generation-summary.md");
  try {
    if (fs.existsSync(markdownFilePath)) {
      fs.rmSync(markdownFilePath);
    }
    fs.writeFileSync(markdownFilePath, markdownContent);
    logMessage(`Markdown file written to ${markdownFilePath}`);
  } catch (error) {
    logMessage(`Error writing markdown file ${markdownFilePath}:${error}`, LogLevel.Error);
    statusCode = 1;
  }
  return statusCode;
}

/**
 * Get the spec paths based on the run mode.
 * @param runMode The run mode.
 * @param specRepoPath The specification repository path.
 * @returns The spec paths.
 */
function getSpecPaths(runMode: string, specRepoPath: string): string[] {
  const specConfigPaths: string[] = [];
  switch (runMode) {
    case "all-specs": {
      specConfigPaths.push(
        ...getAllTypeSpecPaths(specRepoPath),
        ...findReadmeFiles(path.join(specRepoPath, "specification"))
      );
      break;
    }
    case "all-typespecs": {
      specConfigPaths.push(...getAllTypeSpecPaths(specRepoPath));
      break;
    }
    case "all-openapis": {
      specConfigPaths.push(...findReadmeFiles(path.join(specRepoPath, "specification")));
      break;
    }
    case "sample-typespecs": {
      specConfigPaths.push("specification/contosowidgetmanager/Contoso.Management/tspconfig.yaml");
    }
  }
  return specConfigPaths;
}

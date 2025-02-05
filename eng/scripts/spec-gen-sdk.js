const fs = require("fs");
const path = require("path");
const {
  findTspConfigFiles,
  findManagementTspConfigFiles,
  findReadmeFiles,
  findResourceManagerReadmeFiles,
  getArgumentValue,
  runSpecGenSdkCommand
} = require("./spec-gen-sdk-utils");

async function generateSdk() {
  const __dirname = path.dirname(__filename);

  const args = process.argv.slice(2);
  const specRepoPath = path.resolve(getArgumentValue(args, "--scp", path.join(__dirname, "..", "..")));
  const sdkLanguage = getArgumentValue(args, "--lang", "azure-sdk-for-net");
  const sdkRepoPath = path.resolve(getArgumentValue(
    args,
    "--sdp",
    path.join(specRepoPath, "..", sdkLanguage)
  ));
  const workingFolder = path.resolve(getArgumentValue(
    args,
    "--wf",
    path.join(specRepoPath, ".."))
  );
  const triggerByPipeline = getArgumentValue(args, "--tr", "false");
  const specRepoCommit = getArgumentValue(args, "--commit", "HEAD");
  const runMode = getArgumentValue(args, "--rm", "sample-typespecs");

  let specConfigPaths = [];
  switch (runMode) {
    case "all-specs": {
      specConfigPaths.push(
        ...findTspConfigFiles(path.join(specRepoPath, "specification")),
        ...findReadmeFiles(path.join(specRepoPath, "specification"))
      );
      break;
    }
    case "all-typespecs": {
      specConfigPaths.push(...findTspConfigFiles(path.join(specRepoPath, "specification")));
      break;
    }
    case "all-openapis": {
      specConfigPaths.push(...findReadmeFiles(path.join(specRepoPath, "specification")));
      break;
    }
    case "all-control-plane-specs": {
      specConfigPaths.push(
        ...findManagementTspConfigFiles(path.join(specRepoPath, "specification")),
        ...findResourceManagerReadmeFiles(path.join(specRepoPath, "specification"))
      );
      break;
    }
    case "all-data-plane-specs": {
      const allTspConfigFiles = findTspConfigFiles(path.join(specRepoPath, "specification"));
      const allManagementTspConfigFiles = findManagementTspConfigFiles(
        path.join(specRepoPath, "specification")
      );
      const allReadmeFiles = findReadmeFiles(path.join(specRepoPath, "specification"));
      const allResourceManagerReadmeFiles = findResourceManagerReadmeFiles(
        path.join(specRepoPath, "specification")
      );
      specConfigPaths = [...allTspConfigFiles, ...allReadmeFiles];
      specConfigPaths = specConfigPaths.filter(
        (file) =>
          !allManagementTspConfigFiles.includes(file) &&
          !allResourceManagerReadmeFiles.includes(file)
      );
      break;
    }
    case "control-plane-typespecs": {
      specConfigPaths.push(...findManagementTspConfigFiles(path.join(specRepoPath, "specification")));
      break;
    }
    case "data-plane-typespecs": {
      const allTspconfigFiles = findTspConfigFiles(path.join(specRepoPath, "specification"));
      const allManagementTspConfigFiles = findManagementTspConfigFiles(
        path.join(specRepoPath, "specification")
      );
      specConfigPaths = allTspconfigFiles.filter(
        (file) => !allManagementTspConfigFiles.includes(file)
      );
      break;
    }
    case "sample-typespecs": {
      const sampleTspConfigFiles = findTspConfigFiles(path.join(specRepoPath, "specification/contosowidgetmanager"));
      specConfigPaths.push(...sampleTspConfigFiles);
    }
  }

  let markdownContent = "# Generation Summary\n";
  markdownContent += `## Specs Failed in Generation\n`;
  let succeededContent = `## Specs Succeeded in Generation\n`;
  let failedCount = 0;
  for (const specConfigPath of specConfigPaths) {
    console.log(`Generating SDK from ${specConfigPath}`);
    let specGenSdkCommand = `spec-gen-sdk --scp ${specRepoPath} --sdp ${sdkRepoPath} --wf ${workingFolder} -l ${sdkLanguage} -c ${specRepoCommit} -t ${triggerByPipeline}`;
    if (specConfigPath.endsWith("tspconfig.yaml")) {
      specGenSdkCommand += ` --tsp-config-relative-path ${specConfigPath}`;
    } else {
      specGenSdkCommand += ` --readme-relative-path ${specConfigPath}`;
    }
    console.log("Command:", specGenSdkCommand);
    try {
      await runSpecGenSdkCommand(specGenSdkCommand);
      console.log("Command executed successfully");
    } catch (error) {
      console.error("Error executing command:", error);
    }

    const executionReportPath = path.join(workingFolder, `${sdkLanguage}_tmp/execution-report.json`)
    try {
      const executionReport = JSON.parse(fs.readFileSync(executionReportPath, "utf8"));
      const executionResult = executionReport.packages[0]?.result;
      console.log("Execution Result:", executionResult);

      // Add package generation result to markdown content
      if (executionResult === "failed") {
        markdownContent += `${specConfigPath},`;
        failedCount++;
      } else {
        succeededContent += `${specConfigPath},`;
      }
    } catch (error) {
      console.error(`Error reading execution report at ${executionReportPath}:`, error);
    }
  }
  markdownContent += `\n${succeededContent}\n`;
  markdownContent += `## Total Specs Failed:\n ${failedCount}\n`;
  markdownContent += `## Total Specs Generated:\n ${specConfigPaths.length}\n\n`;
  // Write a markdown file to be rendered by the Azure DevOps pipeline
  const markdownFilePath = path.join(workingFolder, "out/logs/generation-summary.md");
  try {
    if (fs.existsSync(markdownFilePath)) {
      fs.rmSync(markdownFilePath);
    }
    fs.writeFileSync(markdownFilePath, markdownContent);
  } catch (error) {
    console.error(`Error writing markdown file ${markdownFilePath}:`, error);
  }
}

generateSdk().catch(console.error);
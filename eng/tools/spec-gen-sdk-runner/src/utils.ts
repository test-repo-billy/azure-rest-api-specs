import { spawn, spawnSync, exec } from "node:child_process";
import path from "node:path";
import fs from "node:fs";
import { LogLevel, logMessage } from "./log.js";
import { promisify } from "node:util";

type Dirent = fs.Dirent;

export const execAsync = promisify(exec);

/**
 * Reset unstaged changes in a git repository
 * @param repoPath The path to the git repository
 * @returns A promise that resolves when the reset is complete
 */
export async function resetGitRepo(repoPath: string): Promise<void> {
  try {
    const { stderr } = await execAsync("git clean -fdx && git reset --hard HEAD", {
      cwd: repoPath,
    });
    if (stderr) {
      logMessage(`Warning during git reset: ${stderr}`, LogLevel.Warn);
    } else {
      logMessage(`Successfully reset git repo at ${repoPath}`, LogLevel.Info);
    }
  } catch (error) {
    throw new Error(`Failed to reset git repo at ${repoPath}: ${error}`);
  }
}

/*
 * Common function to find files recursively with case-insensitive matching
 */
export function findFilesRecursive(directory: string, fileName: string): string[] {
  let results: string[] = [];
  const list: Dirent[] = fs.readdirSync(directory, { withFileTypes: true });

  for (const dirent of list) {
    const filePath = path.join(directory, dirent.name);
    if (dirent.isDirectory()) {
      results = [...results, ...findFilesRecursive(filePath, fileName)];
    } else if (dirent.isFile() && dirent.name.toLowerCase() === fileName.toLowerCase()) {
      results.push(getRelativePathFromSpecification(filePath));
    }
  }

  return results;
}

export function findReadmeFiles(directory: string): string[] {
  return findFilesRecursive(directory, "readme.md");
}

export function getArgumentValue(args: string[], flag: string, defaultValue: string): string {
  const index = args.indexOf(flag);
  return index !== -1 && args[index + 1] ? args[index + 1] : defaultValue;
}

/*
 * Get the relative path from the specification folder
 */
export function getRelativePathFromSpecification(absolutePath: string): string {
  const specificationIndex = absolutePath.indexOf("specification/");
  if (specificationIndex !== -1) {
    return absolutePath.slice(Math.max(0, specificationIndex));
  }
  return absolutePath;
}

/*
 * Run the spec-gen-sdk command
 */
export async function runSpecGenSdkCommand(specGenSdkCommand: string[]): Promise<void> {
  return new Promise((resolve, reject) => {
    const childProcess = spawn("npx", specGenSdkCommand, {
      shell: false,
      stdio: "inherit",
      env: process.env,
    });
    childProcess.on("error", (error) => {
      reject(new Error(`Failed to start process: ${error.message}`));
    });
    childProcess.on("exit", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`Process exited with code ${code}`));
      }
    });
  });
}

/*
 * Get the list of all type spec project folder paths
 */
export function getAllTypeSpecPaths(specRepoPath: string): string[] {
  const scriptPath = path.resolve(specRepoPath, "eng/scripts/Get-TypeSpec-Folders.ps1");
  const args = [
    "-NoProfile",
    "-ExecutionPolicy",
    "Bypass",
    "-File",
    scriptPath,
    "-CheckAll",
    "$true",
  ];
  const output = runPowerShellScript(args);
  if (!output) {
    logMessage("Error getting type spec paths", LogLevel.Error);
    return [];
  }
  try {
    const specConfigPaths = output.split("\n").map((line) => path.join(line, "tspconfig.yaml"));
    //remove the last element which is 'true' or 'false'
    specConfigPaths.pop();
    return specConfigPaths;
  } catch (error) {
    logMessage(`Error parsing PowerShell output:${error}`, LogLevel.Error);
    return [];
  }
}

/*
 * Run the PowerShell script
 */
export function runPowerShellScript(args: string[]): string | undefined {
  const result = spawnSync("/usr/bin/pwsh", args, { encoding: "utf8" });
  if (result.error) {
    logMessage(`Error executing PowerShell script:${result.error}`, LogLevel.Error);
    return undefined;
  }
  if (result.stderr) {
    logMessage(`PowerShell script error output:${result.stderr}`, LogLevel.Error);
  }
  return result.stdout?.trim();
}

// Function to call Get-ChangedFiles from PowerShell script
export function getChangedFiles(
  specRepoPath: string,
  baseCommitish: string = "HEAD^",
  targetCommitish: string = "HEAD",
  diffFilter: string = "d",
): string[] | undefined {
  const scriptPath = path.resolve(specRepoPath, "eng/scripts/ChangedFiles-Functions.ps1");
  const args = [
    "-Command",
    `& { . '${scriptPath}'; Get-ChangedFiles '${baseCommitish}' '${targetCommitish}' '${diffFilter}' }`,
  ];

  const output = runPowerShellScript(args);
  if (output) {
    return output
      .split("\n")
      .map((line) => line.trim())
      .filter((line) => line.length > 0);
  }
  return undefined;
}

export function findParentWithFile(
  startPath: string,
  searchFile: RegExp,
  specFolder: string,
): string | undefined {
  let currentPath = startPath;
  while (currentPath.startsWith(specFolder)) {
    const files = fs.readdirSync(currentPath);
    if (files.some((file) => searchFile.test(file))) {
      return currentPath;
    }
    currentPath = path.dirname(currentPath);
  }
  return undefined;
}

export function searchRelatedParentFolders(
  files: string[],
  options: { searchFileRegex: RegExp; specFolder: string },
): { [folderPath: string]: string[] } {
  const result: { [folderPath: string]: string[] } = {};

  for (const file of files) {
    const parentFolder = findParentWithFile(
      path.dirname(file),
      options.searchFileRegex,
      options.specFolder,
    );
    if (parentFolder) {
      if (!result[parentFolder]) {
        result[parentFolder] = [];
      }
      result[parentFolder].push(file);
    }
  }

  return result;
}

export function searchSharedLibrary(
  files: string[],
  options: { searchFileRegex: RegExp; specFolder: string },
): string[] {
  return files.filter((file) => options.searchFileRegex.test(file));
}

export function searchRelatedTypeSpecProjectBySharedLibrary(
  sharedLibraries: string[],
  options: { searchFileRegex: RegExp; specFolder: string },
): { [folderPath: string]: string[] } {
  const result: { [folderPath: string]: string[] } = {};

  for (const library of sharedLibraries) {
    const libraryDir = path.dirname(library);
    const parentProjects = findAllTypeSpecProjects(
      libraryDir,
      options.searchFileRegex,
      options.specFolder,
    );

    for (const projectPath of parentProjects) {
      if (!result[projectPath]) {
        result[projectPath] = [];
      }
      result[projectPath].push(library);
    }
  }

  return result;
}

function findAllTypeSpecProjects(
  startPath: string,
  searchFile: RegExp,
  specFolder: string,
): string[] {
  const projects: string[] = [];
  let currentPath = startPath;

  while (currentPath.startsWith(specFolder)) {
    const files = fs.readdirSync(currentPath);
    if (files.some((file) => searchFile.test(file))) {
      projects.push(currentPath);
    }
    currentPath = path.dirname(currentPath);
  }

  return projects;
}

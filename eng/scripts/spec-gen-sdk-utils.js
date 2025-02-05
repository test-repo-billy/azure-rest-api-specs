/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable unicorn/prefer-ternary */
const { exec } = require("child_process");
const path = require("path");
const fs = require("fs");
const { promisify } = require("util");

const execAsync = promisify(exec);

// Common function to find files recursively with case-insensitive matching
function findFilesRecursive(directory, fileName) {
  let results = [];
  const list = fs.readdirSync(directory, { withFileTypes: true });

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

function findTspConfigFiles(directory) {
  return findFilesRecursive(directory, "tspconfig.yaml");
}

function findManagementTspConfigFiles(directory) {
  let results = [];
  const tspconfigRegex = new RegExp(".*/[^/]+\.management/([^/]+/)*tspconfig\\.yaml$", "i");
  const list = fs.readdirSync(directory, { withFileTypes: true });

  for (const dirent of list) {
    const filePath = path.join(directory, dirent.name);
    if (dirent.isDirectory()) {
      if (filePath.toLowerCase().endsWith(".management")) {
        results = [...results, ...findFilesRecursive(filePath, "tspconfig.yaml")];
      } else {
        results = [...results, ...findManagementTspConfigFiles(filePath)];
      }
    } else if (tspconfigRegex.test(filePath)) {
      results.push(getRelativePathFromSpecification(filePath));
    }
  }

  return results;
}

function findReadmeFiles(directory) {
  return findFilesRecursive(directory, "readme.md");
}

function findResourceManagerReadmeFiles(directory) {
  let results = [];
  const readmeRegex = new RegExp(".*/resource-manager/([^/]+/)*readme\\.md$");
  const list = fs.readdirSync(directory, { withFileTypes: true });

  for (const dirent of list) {
    const filePath = path.join(directory, dirent.name);
    if (dirent.isDirectory()) {
      if (filePath.endsWith("/resource-manager")) {
        results = [...results, ...findFilesRecursive(filePath, "readme.md")];
      } else {
        results = [...results, ...findResourceManagerReadmeFiles(filePath)];
      }
    } else if (readmeRegex.test(filePath)) {
      results.push(getRelativePathFromSpecification(filePath));
    }
  }

  return results;
}

function getArgumentValue(args, flag, defaultValue) {
  const index = args.indexOf(flag);
  return index !== -1 && args[index + 1] ? args[index + 1] : defaultValue;
}

function getRelativePathFromSpecification(absolutePath) {
  const specificationIndex = absolutePath.indexOf("specification/");
  if (specificationIndex !== -1) {
    return absolutePath.substring(specificationIndex);
  }
  return absolutePath;
}

async function runSpecGenSdkCommand(specGenSdkCommand) {
  try {
    const { stdout } = await execAsync(specGenSdkCommand, { stdio: "inherit" });
    return stdout;
  } catch (error) {
    throw new Error(error.stderr || error.message);
  }
}

module.exports = {
  findFilesRecursive,
  findTspConfigFiles,
  findManagementTspConfigFiles,
  findReadmeFiles,
  findResourceManagerReadmeFiles,
  getArgumentValue,
  runSpecGenSdkCommand
};
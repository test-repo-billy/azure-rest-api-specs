import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";
import "@azure-tools/typespec-azure-resource-manager";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager;

@@flattenProperty(TrackedResource.properties);

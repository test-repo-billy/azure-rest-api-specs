import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "@typespec/http";

using Azure.Core;
using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureHealthInsights;

interface RadiologyInsights {
  #suppress "@azure-tools/typespec-azure-core/no-rpc-path-params" "Service uses a jobId in the path"
  @summary("Get Radiology Insights job details")
  @tag("RadiologyInsights")
  @doc("Gets the status and details of the Radiology Insights job.")
  @get
  @route("/radiology-insights/jobs/{id}")
  getJob(@path id: string): OkResponse;
}

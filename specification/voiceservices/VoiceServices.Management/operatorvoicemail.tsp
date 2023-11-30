// Definitions for the OperatorVoicemailInstance resource

import "@TypeSpec-lang/openapi";
import "@TypeSpec-lang/rest";
import "@azure-tools/TypeSpec-providerhub";
import "@azure-tools/TypeSpec-autorest";
import "@azure-tools/TypeSpec-azure-core";
import "@azure-tools/TypeSpec-azure-resource-manager";

namespace Microsoft.VoiceServices;

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;

@doc("A OperatorVoicemailInstance resource")
model OperatorVoicemailInstance is TrackedResource<OperatorVoicemailInstanceProperties> {
  @pattern("^[a-zA-Z][a-zA-Z0-9-]{2,23}$")
  @key("operatorVoicemailInstanceName")
  @segment("operatorVoicemailInstances")
  @doc("Unique identifier for this Operator Voicemail deployment")
  @visibility("Read")
  @path
  name: string;

  ...ResourceSku;
}

@doc("Details of SIP trunk.")
model OperatorVoicemailVoipConnection {
  @doc("Domain name of the peer connecting to Azure Operator Voicemail over this SIP trunk. This must match the common name of the TLS certificate presented by the peer.")
  @visibility("read", "update", "create")
  remoteDomain: string;

  @doc("The allowed source IP address or CIDR ranges for signaling")
  @visibility("read", "update", "create")
  allowedSignalingSourceAddressPrefixes: string[];

  @doc("The allowed source IP address or CIDR ranges for media")
  @visibility("read", "update", "create")
  allowedMediaSourceAddressPrefixes: string[];
}

@doc("Details of the OperatorVoicemailInstance resource.")
model OperatorVoicemailInstanceProperties is ResourceProperties {
  @doc("The set of SIP trunks to be configured on this deployment")
  @TypeSpec.OpenAPI.extension("x-ms-identifiers", ["remoteDomain"])
  @visibility("read", "update", "create")
  @minItems(1)
  voipConnections: OperatorVoicemailVoipConnection[];
}

@added(Versions.v2023_03_01_preview)
@removed(Versions.v2023_04_03)
@armResourceOperations
interface OperatorVoicemailInstances
  extends ResourceRead<OperatorVoicemailInstance>,
    ResourceCreate<OperatorVoicemailInstance>,
    ResourceDelete<OperatorVoicemailInstance>,
    ResourceListBySubscription<OperatorVoicemailInstance>,
    ResourceListByParent<OperatorVoicemailInstance>,
    ResourceUpdateNoProperties<OperatorVoicemailInstance> {}

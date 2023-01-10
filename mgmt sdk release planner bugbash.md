Welcome to Azure Mgmt SDK Release Planner App.The App targets to provide a smooth E2E experience to release Mgmt SDKs.
- App Link: https://aka.ms/ppe-sdk-workflow
- Please provide feedbacks by [creating github issue](https://github.com/Azure/azure-sdk-tools/issues/new) with label `Engagement Experience`.

_As the app is still in Pre-preduction, the app doesn't block you from going to next step when you haven't meet the requirements in some pages._

## Instructions

When trying the app, please pay attention to the following steps.
  - __Step 1 ~ 4 describe how to go to the Mgmt SDK Release.__
  - __Step 5 provides a spec PR for your test.__
  - __Step 6 provides a .Net SDK PR for your test.__

### The following are details:

__Step 1:__ When opening the app, please bind you service to `Release Planner Test Service`. If you are binding to other service, please change it.

  <img src="https://user-images.githubusercontent.com/40835867/211483596-80f69518-dae1-426f-a9e8-a354a2eaa636.png" width="500" />
  
__Step 2:__ Create a Release Plan for Mgmt Release.

  <img src="https://user-images.githubusercontent.com/40835867/211483974-ea54bef0-7007-458f-8164-a1624c7707c2.png" width="500" />
  
__Step 3:__ When the release plan is created, you can find you release plan is the latest one. Please open it.

  <img src="https://user-images.githubusercontent.com/40835867/211484416-5126b51a-705c-4e56-9884-3e7dd702fb71.png" width="500" />
  
__Step 4:__ You can go to the `Management-plane API Readiness` App and `Managenment-plane SDK Release` App one by one.

  <img src="https://user-images.githubusercontent.com/40835867/211484942-fc7137fa-63e7-4fcf-aec5-9da605826768.png" width="500" />
  
__Step 5:__ In `Release Planner Test Service`, it asks you to associate to a spec PR. Here, we have prepared a PR and you can used it: `https://github.com/Azure/azure-rest-api-specs/pull/22119`.

  <img src="https://user-images.githubusercontent.com/40835867/211486201-ea883c75-53b4-422d-b8ba-ec9e589ea0f6.png" width="500" />
  
__Step 6:__ In page `Create a Pull Request & Generate Code` of `Managenment-plane SDK Release` App, you can choose to associate existing .Net SDK PR or generate a new one. 

  - If you want to associate existing .Net PR, you can use the one we have prepared: `https://github.com/openapi-env-test/azure-sdk-for-net/pull/1433`.
  - If you want to generate .Net SDK PR, please expect the CI failure in step `Monitor CI Job and APIView Generation`, but it doesn't block you.
    
  <img src="https://user-images.githubusercontent.com/40835867/211486944-f9caf00f-1eb9-4463-b6e0-7fba78d3953a.png" width="500" />



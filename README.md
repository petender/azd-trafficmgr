# Traffic Manager Profile with WebApp Endpoints in 3 regions
This scenario deploys identical Azure Web App Service websites in 3 different regions, together with a Traffic Manager Load Balancing Profile.

This repo contains an AZD template which deploys Azure Traffic Manager, together with App Services-based endpoints. The scenario can be deployed to Azure using the [Azure Developer CLI - AZD](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/overview). 

💪 This template scenario is part of the larger **[Microsoft Trainer Demo Deploy Catalog](https://aka.ms/trainer-demo-deploy)**.

## ⬇️ Installation
- [Azure Developer CLI - AZD](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
    - When installing AZD, the above the following tools will be installed on your machine as well, if not already installed:
        - [GitHub CLI](https://cli.github.com)
        - [Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
    - You need Owner or Contributor access permissions to an Azure Subscription to  deploy the scenario.

## 🚀 Deploying the scenario in 4 steps:

1. Create a new folder on your machine.
```
mkdir petender/azd-trafficmgr
```
2. Next, navigate to the new folder.
```
cd petender/azd-trafficmgr
```
3. Next, run `azd init` to initialize the deployment.
```
azd init -t petender/azd-trafficmgr
```
4. Last, run `azd up` to trigger an actual deployment.
```
azd up
```

⏩ Note: you can delete the deployed scenario from the Azure Portal, or by running ```azd down --purge --force``` from within the initiated folder. The 'purge' parameter will remove any resources who would typically be kept in a soft-delete status.

## What is the demo scenario about?

- Use the [demo guide](https://github.com/petender/azd-trafficmgr/blob/main/demoguide/demoguide.md) for inspiration for your demo

## 💭 Feedback and Contributing
Feel free to create issues for bugs, suggestions or Fork and create a PR with new demo scenarios or optimizations to the templates. 
If you like the scenario, consider giving a GitHub ⭐
 

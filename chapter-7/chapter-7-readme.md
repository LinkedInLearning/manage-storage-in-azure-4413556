# Instructions

These files are used in the demos for chapter 7. The instructions to build each environment are below.

Each set of commands are designed to run from inside the chapter folder so:

```bash
cd chapter-7

az group create --resource-group rg-07-01 --location <location>

az deployment group create --resource-group rg-07-01 --template-file 07_01/main.bicep --parameters resourceSuffix=0701 location=<location>

etc...
```

## Chapter 07_02 - Manage storage tiers for blobs and files

These commands create a general purpose V2 storage account with blob public access enabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-07-02 --location <location>
    ```


2. Create a storage account

    ```bash
    az deployment group create --resource-group rg-07-02 --template-file 07_02/standard-storage.bicep --parameters resourceSuffix=0702 location=<location>
    ```

## Chapter 07_03 - Lifecycle management policies and rules

These commands create a general purpose V2 storage account with blob public access enabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-07-03 --location <location>
    ```


2. Create a storage account with two ccontainers to use for filtering

    ```bash
    az deployment group create --resource-group rg-07-03 --template-file 07_03/standard-storage.bicep --parameters resourceSuffix=0703 location=<location>
    ```

## Chapter 07_04 - Monitoring Azure Storage & Monitoring Azure Storage with Storage Insights and Workbooks

These commands create a general purpose V2 storage account with blob public access enabled and an Azure Function to add the python triggers to

Note the deployment of the function app for this demo was written specifically to run on WSL2 with docker and devcontainers in vscode.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-07-04 --location <location>
    ```

2. Retrieve the Object ID of the logged in identity

    ```bash
    az ad signed-in-user show --query id -o tsv
    ```

3. Create a storage account with two ccontainers to use for filtering

    ```bash
    az deployment group create --resource-group rg-07-04 --template-file 07_04/main.bicep --parameters resourceSuffix=0704 location=<location> identityPrincipalId=<id>
    ```

4. Deploy the function app using visual studio code

    Ensure that the [Dev Containers Extension](https://code.visualstudio.com/docs/devcontainers/containers) and the [Azure Tools Extension](https://code.visualstudio.com/docs/azure/extensions) are installed in visual studio code

    cd to folder 07_04/azure-function and open vscode from inside this folder

    VSCode will ask if you would like to reload the current project in a container, choose yes. For more information on devcontainers [follow this link](https://code.visualstudio.com/docs/devcontainers/tutorial).

    You can now setup and [run locally](https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=python#run-functions-locally) or push the funciton to the funciton app created above. To do this sign into the Azure Tools extension and [follow these instructions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=python#republish-project-files), but note the icon to upload the function is no longer a cloud, click on the lightning bolt and select to "deploy function".

    **Note - you will have to edit the read_blob.py and write_blob.py files before deploying the function if you named your resource group anything other than 07_04, as the storage account name is hardcoded into the code.**

    

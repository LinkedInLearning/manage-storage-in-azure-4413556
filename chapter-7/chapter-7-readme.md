# Instructions

These files are used in the demos for chapter 7. The instructions to build each environment are below.

Each set of commands are designed to run from inside the chapter folder so:

```bash
cd chapter-7

az group create --resource-group rg-07-01 --location <location>

az deployment group create --resource-group rg-07-01 --template-file 07_01/main.bicep --parameters resourceSuffix=0701 location=<location>

etc...
```

## Chapter 07_02 - Access tiers for blobs and storage tiers for files

These commands create a general purpose V2 storage account with blob public access enabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-07-02 --location <location>
    ```


2. Create a storage account

    ```bash
    az deployment group create --resource-group rg-07-02 --template-file 07_02/standard-storage.bicep --parameters resourceSuffix=0702 location=<location>
    ```

## Chapter 07_03 - Lifecycle management policies

These commands create a general purpose V2 storage account with blob public access enabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-07-03 --location <location>
    ```


2. Create a storage account with two ccontainers to use for filtering

    ```bash
    az deployment group create --resource-group rg-07-03 --template-file 07_03/standard-storage.bicep --parameters resourceSuffix=0703location=<location>
    ```

## Chapter 07_04 - Monitoring storage

These commands create a general purpose V2 storage account with blob public access enabled and an Azure Function to add the python triggers to

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
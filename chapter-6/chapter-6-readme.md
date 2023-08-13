# Instructions

These files are used in the demos for chapter 6. The instructions to build each environment are below.

Each set of commands are designed to run from inside the chapter folder so:

```bash
cd chapter-6

az group create --resource-group rg-06-01 --location <location>

az deployment group create --resource-group rg-06-01 --template-file 06_01/main.bicep --parameters resourceSuffix=0601 location=<location>

etc...
```

## Chapter 06_01 - Encryption at rest, encryption scopes and encryption in transit in practice

These commands create a general purpose V2 storage account with blob public access disabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-06-01 --location <location>
    ```


2. Create a storage account and a key vault

    ```bash
    az deployment group create --resource-group rg-06-01 --template-file 06_01/main.bicep --parameters resourceSuffix=0601 location=<location>
    ```


## Chapter 06_02 - Soft delete and versioning for blobs, containers and file shares

These commands create a general purpose V2 storage account with blob public access disabled and soft delete and versioning disabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-06-02 --location <location>
    ```


2. Create a storage account and a key vault

    ```bash
    az deployment group create --resource-group rg-06-02 --template-file 06_02/standard-storage.bicep --parameters resourceSuffix=0602 location=<location>
    ```



## Chapter 06_03 - Point in time restore for blob data

These commands create a general purpose V2 storage account with change feed enabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-06-03 --location <location>
    ```


2. Create a storage account with just change feed enabled

    ```bash
    az deployment group create --resource-group rg-06-03 --template-file 06_03/standard-storage.bicep --parameters resourceSuffix=0603 location=<location>
    ```

3. Create a storage account point in time restore enabled

    ```bash
    az deployment group create --resource-group rg-06-03 --template-file 06_03/standard-storage-restore.bicep --parameters resourceSuffix=0603 location=<location>
    ```

    ## Chapter 06_04 - Immutable storage for business-critical data

    These commands create a general purpose V2 storage account.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-06-04 --location <location>
    ```


2. Create a storage account

    ```bash
    az deployment group create --resource-group rg-06-04 --template-file 06_04/standard-storage.bicep --parameters resourceSuffix=0604 location=<location>
    ```

2. Create a storage account with version immutability enabled

    ```bash
    az deployment group create --resource-group rg-06-04 --template-file 06_04/standard-storage-verimmutability.bicep --parameters resourceSuffix=0604 location=<location>
    ```
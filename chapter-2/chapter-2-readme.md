# Instructions

These files are used in the demos for chapter 2. The instructions to build each environment are below.

Each set of commands are designed to run from inside the chapter folder so:

```bash
cd chapter-2

az group create --resource-group rg-02-02 --location <location>

az deployment group create --resource-group rg-02-02 --template-file 02_02/standard-storage.bicep --parameters resourceSuffix=0202 location=<location>

etc...
```

## Chapter 02_02 - Backing up Azure File Shares and Blobs Demo

These commands create a general purpose V2 storage account with file share, two blob containers and a couple of blobs in each container

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-02-02 --location <location>
    ```

2. Deploy the resources into the resource group, replace <location> with your location of choice

    ```bash
    az deployment group create --resource-group rg-02-02 --template-file 02_02/standard-storage.bicep --parameters resourceSuffix=0202 location=<location>
    ```

Once the resources are deployed, copy in the two files from the files folder in 02_03/data/files, across to the fileshare, you can then follow the demo.

## Chapter 02_03 - Disaster recovery and failover

These commands create a general purpose V2 storage account in RAGRS redundancy, two blob containers and a couple of blobs in each container

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-02-03 --location <location>
    ```

2. Deploy the resources into the resource group, replace <location> with your location of choice

    ```bash
    az deployment group create --resource-group rg-02-03 --template-file 02_03/standard-storage-ragrs.bicep --parameters resourceSuffix=0203 location=<location>
    ```

## Chapter 02_04 - Object replication for blob data

These commands create three standard general purpose v2 accounts with local redundancy. Change feed and blob versioning are enabeld on the source account, and just blob versioning on the target account.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-02-04 --location <location>
    ```

2. Deploy the resources into the resource group, replace <location> with your location of choice

    ```bash
    az deployment group create --resource-group rg-02-04 --template-file 02_04/standard-storage.bicep --parameters resourceSuffix=0204 location=<location>
    ```

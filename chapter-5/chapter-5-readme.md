# Instructions

These files are used in the demos for chapter 5. The instructions to build each environment are below.

Each set of commands are designed to run from inside the chapter folder so:

```bash
cd chapter-5

az group create --resource-group rg-05-01 --location <location>

az deployment group create --resource-group rg-05-01 --template-file 05_01/main.bicep --parameters resourcePrefix=0501 location=<location>

etc...
```

## Chapter 05_01 - Deploying Azure File Sync

These commands create the Virtual Machine, Networking and Storage with a single file share named fileSync. 


1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-05-01 --location <location>
    ```

2. Deploy the resources into the resource group, replace <location> with your location of choice

    ```bash
    az deployment group create --resource-group rg-05-01 --template-file 05_01/main.bicep --parameters resourcePrefix=0501 location=<location>
    ```

    You will be prompted to enter an admin password for the virtual machine, don't forget to note it down! The username is admin0501

## Chapter 05_02 Mounting an SMB File Share in Windows

These commands create the Virtual Machine, Networking and Storage with a single file share named filesmount. 


1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-05-02 --location <location>
    ```

2. Deploy the resources into the resource group, replace <location> with your location of choice

    ```bash
    az deployment group create --resource-group rg-05-02 --template-file 05_02/main.bicep --parameters resourceSuffix=0502 location=<location>
    ```

    You will be prompted to enter an admin password for the virtual machine, don't forget to note it down! The username is admin0502

## Chapter 05_03 Mounting an NFS File Share in Linux

These commands creates a Windows and Ubuntu VM, Networking and Storage with a single file share named nfsmount. 


1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-05-03 --location <location>
    ```

2. Deploy the resources into the resource group, replace <location> with your location of choice

    ```bash
    az deployment group create --resource-group rg-05-03 --template-file 05_03/main.bicep --parameters resourceSuffix=0503 location=<location>
    ```

    You will be prompted to enter an admin password for the virtual machines, don't forget to note it down! The username is admin0503

Below is the line for fstab used in the demo

```bash
<YourStorageAccountName>.file.core.windows.net:/<YourStorageAccountName>/<FileShareName> /mount/<YourStorageAccountName>/<FileShareName> nfs vers=4,minorversion=1,sec=sys 0 0
```
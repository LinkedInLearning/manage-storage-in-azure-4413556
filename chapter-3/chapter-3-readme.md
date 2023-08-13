# Instructions

These files are used in the demos for chapter 3. The instructions to build each environment are below.

Each set of commands are designed to run from inside the chapter folder so:

```bash
cd chapter-3

az group create --resource-group rg-03-01 --location <location>

az deployment group create --resource-group rg-03-01 --template-file 03_01/main.bicep --parameters resourceSuffix=0301 location=<location>

etc...
```

## Chapter 03_01 - Storage account firewalls and virtual network access

These commands create a general purpose V2 storage account with two blob containers and a couple of blobs in each container

And a vnet which contains one virtual machine with a public and private IP address.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-03-01 --location <location>
    ```


2. Create a storage account, vnet and virtual machine

    ```bash
    az deployment group create --resource-group rg-03-01 --template-file 03_01/main.bicep --parameters resourceSuffix=0301 location=<location>
    ```

    You will be promoted for an admin password, note it down to access the VM!

## Chapter 03_02 - Private endpoints for Azure Storage

These commands create a general purpose V2 storage account with two blob containers and a couple of blobs in each container

And a vnet which contains one virtual machine with a public and private IP address and a seperate subnet ready for the private link

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-03-02 --location <location>
    ```


2. Create a storage account, vnet and virtual machine

    ```bash
    az deployment group create --resource-group rg-03-02 --template-file 03_02/main.bicep --parameters resourceSuffix=0302 location=<location>
    ```

    You will be promoted for an admin password, note it down to access the VM!


    ## Chapter 03_03 - Create and manage a storage Account with Azure PowerShell and Executing Azure PowerShell in scripts with the Cloud Shell code editor

    There is no setup for this video, the commands are walked through on screen

    1. Using Azure Powershell on the command line

    Open create-storage.ps1 and set the location parameter at the top of the script to one of your choosing. Then paste each line into the cloud shell following the video.


    2. Running a script from the cloud shell

        Clone the linked in learning git repo for this course:

        ```pwsh
        git clone
        ```

        cd into chapter-3

        ```pwsh
        cd LIL*
        cd chapter-3
        ```

        Open the cloud editor

        ```pwsh
        code .
        ```

        Review the file and close the editor (top right of editor, in some browsers the 3 dots disappear)

        Execute the script, below is just an example, you can use any small suffix and any location of the three set as valid in the script.

        ```pwsh
        ./03_03/create-storage-splatting.ps1 -StorageAccountSuffix "0303" -ResourceGroup "rg-03-03" -Location "westeurope"
        ```

    ## Chapter 03_04 - Create and manage a Storage Account with the Azure CLI

    There is no setup for this video, the commands are walked through on screen

    1. Running an Azure CLI bash script on the command line

    Open create-storage.sh to set the values as you wish and click save, execute the script using

    ```bash
    ./03_04/create-storage.sh
    ```

    If you recieve an error you may need to make the file executable

    ```bash
    chmod +x ./03_04/create-storage.sh
    ```

    ## Chapter 03_05 - Deploy infrastructure for Azure Storage using Azure Bicep Demo

    There is no setup for this video, the files are explained on screen and then deployed using
    
    ```bash
    az deployment group create --resource-group rg-03-05 --template-file 03_05/main.bicep --parameters resourceSuffix=0305 location=uksouth
    ```





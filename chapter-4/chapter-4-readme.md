# Instructions

These files are used in the demos for chapter 4. The instructions to build each environment are below.

Each set of commands are designed to run from inside the chapter folder so:

```bash
cd chapter-4

az group create --resource-group rg-03-04 --location <location>

az deployment group create --resource-group rg-03-04 --template-file 04_01/main.bicep --parameters resourceSuffix=0401 location=<location>

etc...
```

## Chapter 04_01 - Control plane and the data plane

These commands create a general purpose V2 storage account with blob public access disabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-04-01 --location <location>
    ```


2. Create a storage account

    ```bash
    az deployment group create --resource-group rg-04-01 --template-file 04_01/standard-storage.bicep --parameters resourceSuffix=0401 location=<location>
    ```


## Chapter 04_02 - Authorising with a shared key

These commands create a general purpose V2 storage account with blob public access disabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-04-02 --location <location>
    ```


2. Create a storage account and output its name

    ```bash
    az deployment group create --resource-group rg-04-02 --template-file 04_02/standard-storage.bicep --parameters resourceSuffix=0402 location=<location>

    az deployment group show --resource-group rg-04-04 -n standard-storage --query properties.outputs.storageName.value
    ```


3. Install azure-storage-blob to cloudshell

    ```pwsh
    pip install azure-blob-storage
    ```

4. Run the account_key python file

edit the file to update the account_url and shared_access_key

    ```pwsh
    cd chapter-4

    python 04_02/list_blobs_account_key.py
    ```


## Chapter 04_03 - Authorising with Azure RBAC

These commands create a general purpose V2 storage account with access key usage disabled and uploads some blobs to a container.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-04-03 --location <location>
    ```


2. Create a storage account and output it's name

    ```bash
    az deployment group create --resource-group rg-04-03 --template-file 04_03/standard-storage.bicep --parameters resourceSuffix=0403 location=<location>

    az deployment group show --resource-group rg-04-04 -n standard-storage --query properties.outputs.storageName.value
    ```

3. Create a service principal and client secret and grant Storage Blob Reader to it

4. Install azure-storage-blob to cloudshell

    ```bash
    pip install azure-blob-storage
    pip install azure-identity
    ```

4. Run the account_key python file

edit the file to update the account_url and shared_access_key

    ```bash
    cd chapter-4

    python 04_03/list_blobs_sp_rbac.py
    ```


## Chapter 04_04 - Authorising with Azure ABAC

These commands create a general purpose V2 storage account with access key usage disabled and uploads some blobs to a container with two different virtual directories.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-04-04 --location <location>
    ```


2. Create a storage account and output its name

    ```bash
    az deployment group create --resource-group rg-04-04 --template-file 04_04/standard-storage.bicep --parameters resourceSuffix=0404 location=<location>

    az deployment group show --resource-group rg-04-04 -n standard-storage --query properties.outputs.storageName.value
    ```


## Chapter 04_05 - Managed identity and Passwordless

These commands create a general purpose V2 storage account with access key usage disabled and public access disabled. It creates a VNet and VM and a private link.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-04-05 --location <location>
    ```


2. Create a storage account, vm, private link, output the VM connect string

    ```bash
    az deployment group create --resource-group rg-04-05 --template-file 04_05/main.bicep --parameters resourceSuffix=0405 location=<location>

    az deployment group show --resource-group rg-04-05 -n main --query properties.outputs.hostname.value
    ```

3. Install windows terminal and python to VM

    ```pwsh
    # Download and install widows terminal
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -outfile Microsoft.VCLibs.x86.14.00.Desktop.appx

    Add-AppxPackage Microsoft.VCLibs.x86.14.00.Desktop.appx

    Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/v1.16.10261.0/Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle -outfile Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle

    Add-AppxPackage Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle

    # Download and install python
    Add-AppxPackage Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle

    .\python-3.10.2-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    
    #Install Azure CLI
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
    rm .\AzureCLI.msi

    # Reload the environment
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    ```

4. Install git

    [Git windows download](https://git-scm.com/download/win) then follow installer.

    Clone the repository

5. Install the required azure packages

    ```pwsh
    pip install azure-identity
    pip install azure-storage-blob
    ```

6. Install vscode

    [From its installer](https://code.visualstudio.com/docs?dv=win)

    Edit chapter-4/04_05/list_blobs_identity.py and list_blobs_default_cred.py and update the storage account name

6. Run managed identity python script

    ```pwsh

    cd into cloned repository

    cd chapter-4

    notepad 04_05/read_blobs_identity.py

    notepad 04_05/read_blobs_default_cred.py

    python ./04_05/read_blobs_identity.py

    python ./04_05/read_blobs_default_cred.py
    ```


## Chapter 04_06 - Shared Access Signatures

These commands create a general purpose V2 storage account with access key usage disabled and public access disabled.

1. Create a resource group, replace <location> with your location of choice

    ```bash
    az group create --resource-group rg-04-06 --location <location>
    ```


2. Create a storage account, vm, private link, output the VM connect string

    ```bash
    az deployment group create --resource-group rg-04-06 --template-file 04_06/standard-storage.bicep --parameters resourceSuffix=0405 location=<location>

    az deployment group show --resource-group rg-04-06 -n standard-storage --query properties.outputs.hostname.value
    ```
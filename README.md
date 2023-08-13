# Manage Storage in Azure
This is the repository for the LinkedIn Learning course `Manage Storage in Azure`. The full course is available from [LinkedIn Learning][lil-course-url]. 

_See the readme file in the main branch for updated instructions and information._

## Instructions
This repository does not have any branches. Clone the entire repository and you get the demo environments and other setups to look at, all in their final state.

Each top level folder corresponds to a chapter, then a folder underneath to a video or videos with files specific to that video. Resources may be required for multiple videos, therefore please use the following table to map a folder to a video title.

| Chapter/Folder  | Video title                                                                                             |
| --------------- | ------------------------------------------------------------------------------------------------------- |
|  -              | Azure Storage and the storage services                                                                  |
|  -              | Azure Storage Types and Performance Tiers                                                               |
|  -              | Creating a Storage Account in the Azure Portal                                                          |
| 01_04           | Working with Azure Storage data in the Portal                                                           |
| 01_04           | An overview of Azure Table Storage and Azure Storage Queues                                             |
| 01_04           | Working with Azure Storage data in Azure Storage Explorer: Adding Tables, entities, queues and messages |
| 01_06           | Migrating and transferring data into Azure Storage                                                      |
| 01_06           | Migrating and transferring data into Azure Storage using AzCopy                                         |
| 01_06           | Hierarchical namespace and SFTP for Blobs                                                               |
| 01_06           | Hierarchical namespace and SFTP for Blobs in practice                                                   |
| Chapter 2       |                                                                                                         |
|  -              | High availability and durability for Azure Storage                                                      |
|  -              | Backing up Azure File Shares and Operational Backup for Blobs                                           |
| 02_02           | Backing up Azure File Shares and Blobs Demo                                                             |
| 02_03           | Disaster recovery and failover                                                                          |
| 02_04           | Object replication for blob data                                                                        |
| Chapter 3       |                                                                                                         |
| 03_01           | Storage account firewalls and virtual network access                                                    |
| 03_02           | Private endpoints for Azure Storage                                                                     |
| 03_03           | Create and manage a storage Account with Azure PowerShell                                               |
| 03_03           | Executing Azure PowerShell in scripts with the Cloud Shell code editor                                  |
| 03_04           | Create and manage a Storage Account with the Azure CLI                                                  |
|  -              | Deploy infrastructure for Azure Storage using Azure Bicep                                               |
| 03_05           | Deploy infrastructure for Azure Storage using Azure Bicep Demo                                          |
| Chapter 4       |                                                                                                         |
| 04_01           | The control plane and the data plane                                                                    |
| 04_02           | Authorize with shared Keys                                                                              |
| 04_03           | Authorize operations with Azure AD and Azure RBAC                                                       |
| 04_04           | Authorize operations with Azure AD and Azure ABAC Storage                                               |
| 04_05           | Accessing storage account data from other Azure Services                                                |
| 04_05           | Enable passwordless Azure AD based access to Azure Storage                                              |
| 04_06           | Shared Access Signatures and Access delegation                                                          |
| Chapter 5       |                                                                                                         |
| 05_01           | Setting up Azure File Sync                                                                              |
| 05_02           | Mounting a file share to Windows Server                                                                 |
| 05_03           | Mounting a file share to Linux                                                                          |
| Chapter 6       |                                                                                                         |
| 06_01           | Encryption at rest and in transit                                                                       |
| 06_01           | Encryption at rest, encryption scopes and encryption in transit in practice                             |
| 06_02           | Soft delete and versioning for blobs, containers and file shares                                        |
|  -              | Change feed for blob data                                                                               |
| 06_03           | Point in time restore for blob data                                                                     |
| 06_04           | Immutable storage for business-critical blob data                                                       |
| Chapter 7       |                                                                                                         |
|                 | Billing, Reserved Capacity and network routing preference for Azure Storage                             |
|  -              | Storage tiers and blob rehydration                                                                      |
| 07_02           | Manage storage tiers for blobs and files                                                                |
| 07_03           | Lifecycle management policies and rules                                                                 |
| 07_04           | Monitoring Azure Storage                                                                                |
| 07_04           | Monitoring Azure Storage with Storage Insights and Workbooks                                            |
| further_reading | Learning more about Azure management                                                                    |


Within each folder is a chapter-X-readme.md file, this contains the commands to be run in the cloudshell to create each environment. The environments allow you to follow along with the videos.

## Installing

The bicep files are designed to be run in Azure Cloudshell. You do not require anything installed locally to use the bicep files. However, if you would like to study the files locally I recommend the following:

1. Install [VS Code](https://code.visualstudio.com/)

2. Add the following extensions to VSCode:

    * [Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)

    * [Azure tools](https://code.visualstudio.com/docs/azure/extensions)

    * [Python](https://code.visualstudio.com/docs/languages/python)

    * [Azure CLI Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azurecli)

    * [PowerShell in Visual Studio Code](https://code.visualstudio.com/docs/languages/powershell)

    * [Avro Data Preview](https://marketplace.visualstudio.com/items?itemName=RandomFractalsInc.vscode-data-preview)

To use the bicep, python and script files in Azure Cloudshell, clone the repository within the cloudshell, CD to the appropriate directory for your video and execute the commands from the chapter-X-readme.md file at the cloudshell command line. For help with Cloudshell, checkout the [quickstart](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart)

There are also further tools shown in the demos, to use these tools you can install from the following links:

3. Get started with [azcopy](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)

4. [Azure Storage Explorer](https://azure.microsoft.com/en-gb/products/storage/storage-explorer)

5. [WinSCP](https://winscp.net/eng/index.php) for windows


[0]: # (Replace these placeholder URLs with actual course URLs)

[lil-course-url]: https://www.linkedin.com/learning/
[lil-thumbnail-url]: http://


from azure.storage.blob import BlobServiceClient
from azure.identity import ManagedIdentityCredential


def get_blob_service_client_app_reg(
    credential: ManagedIdentityCredential, account_url: str
):
    # Create the BlobServiceClient object
    blob_service_client = BlobServiceClient(account_url, credential=credential)

    return blob_service_client


def read_blob(blob_service_client: BlobServiceClient, container_name, blob_name):
    blob_client = blob_service_client.get_blob_client(
        container=container_name, blob=blob_name
    )

    downloader = blob_client.download_blob(max_concurrency=1, encoding="UTF-8")
    blob_text = downloader.readall()
    print(f"Blob contents: {blob_text}")


if __name__ == "__main__":
    account_url = "https://<storage-account-name>.blob.core.windows.net"
    credential = ManagedIdentityCredential()

    blob_service_client = get_blob_service_client_app_reg(credential, account_url)

    read_blob(blob_service_client, container_name="json", blob_name="blob2.json")

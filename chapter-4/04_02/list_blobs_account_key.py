from azure.storage.blob import BlobServiceClient


def get_blob_service_client_account_key(shared_access_key: str, account_url: str):
    # Create the BlobServiceClient object
    blob_service_client = BlobServiceClient(account_url, credential=shared_access_key)

    return blob_service_client


def list_blobs(blob_service_client: BlobServiceClient, container_name):
    container_client = blob_service_client.get_container_client(
        container=container_name
    )

    blob_list = container_client.list_blobs()

    for blob in blob_list:
        print(f"Name: {blob.name}")


if __name__ == "__main__":
    account_url = "https://<storage-account-name>.blob.core.windows.net"
    shared_access_key = "<account-key>"
    container_name = "testaccountkey"

    blob_service_client = get_blob_service_client_account_key(
        shared_access_key, account_url
    )

    list_blobs(blob_service_client, container_name)

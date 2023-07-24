import os
import azure.functions as func
import logging
import datetime
import tempfile
import itertools

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient


rb = func.Blueprint()


@rb.schedule(schedule="0 */4 * * * *", arg_name="readtimer", run_on_startup=True)
@rb.function_name("readtimer")
def TimerTrigger(readtimer: func.TimerRequest) -> None:
    if readtimer.past_due:
        logging.info("The timer readtimer is past due!")

    utc_timestamp = (
        datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()
    )

    logging.info("mytimer trigger function ran at %s", utc_timestamp)

    # Never do this! It is for simplicity for this walkthrough
    # Pass in using secrets from the fucntion configuration
    account_url = "https://sa0704dgp3vjlagavvu.blob.core.windows.net"
    default_credential = DefaultAzureCredential()

    # Create the blob service client object
    blob_service_client = BlobServiceClient(account_url, credential=default_credential)
    # Create the container client
    container_client = blob_service_client.get_container_client("loadcontainer1")
    temp_file_path = tempfile.gettempdir()

    # Retrieve the first 10 blobs from container1
    blob_list = container_client.list_blob_names()
    top_ten_blobs = itertools.islice(blob_list, 10)
    for blob_name in top_ten_blobs:
        download_file_path = os.path.join(temp_file_path, blob_name)
        logging.info(blob_name)
        with open(file=download_file_path, mode="wb") as download_file:
            download_file.write(container_client.download_blob(blob_name).readall())
        os.remove(download_file_path)
    logging.info("readtimer trigger function finished at %s", utc_timestamp)

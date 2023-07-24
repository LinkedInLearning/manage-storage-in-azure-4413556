import os, time
import azure.functions as func
import logging
import datetime
import tempfile

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient


wb = func.Blueprint()

@wb.schedule(schedule="0 */2 * * * *", arg_name="writetimer", run_on_startup=True)
@wb.function_name("writetimer")
def TimerTrigger(writetimer: func.TimerRequest) -> None:
    if writetimer.past_due:
        logging.info("The timer writetimer is past due!")

    utc_timestamp = (
        datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()
    )

    logging.info("mytimer trigger function ran at %s", utc_timestamp)

    # Never do this! It is for simplicity for this walkthrough
    # Pass in using secrets from the fucntion configuration
    account_url = "https://sa0704dgp3vjlagavvu.blob.core.windows.net"
    default_credential = DefaultAzureCredential()

    # Create the BlobServiceClient object
    blob_service_client = BlobServiceClient(account_url, credential=default_credential)

    temp_file_path = tempfile.gettempdir()

    # Create a file in the local data directory to upload and download
    local_file_name = "blob" + time.strftime("%Y%m%d%H%M%S") + ".txt"
    upload_file_path = os.path.join(temp_file_path, local_file_name)

    # Write text to the tempfile
    file = open(file=upload_file_path, mode="w")
    file.write("Writing blobs for 07_04 demo!")
    file.close()

    blob_client = blob_service_client.get_blob_client(
        container="loadcontainer1", blob=local_file_name
    )
    # Upload the created file to container 1
    with open(file=upload_file_path, mode="rb") as data:
        blob_client.upload_blob(data)

    blob_client = blob_service_client.get_blob_client(
        container="loadcontainer2", blob=local_file_name
    )
    # Upload the created file to container 2
    with open(file=upload_file_path, mode="rb") as data:
        blob_client.upload_blob(data)
    
    #Remove the tempfile
    os.remove(upload_file_path)

    logging.info("mytimer trigger function finished at %s", utc_timestamp)

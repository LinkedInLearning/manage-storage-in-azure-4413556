FROM mcr.microsoft.com/azure-functions/python:4-python3.9-core-tools
COPY requirements.txt /root/requirements.txt
# The folloiwng line is to filx a base docker image signature issue until
# it is patched
RUN rm -f /etc/apt/sources.list.d/yarn.list
# hadolint ignore=DL3013
RUN apt-get update && apt-get install -y \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --requirement /root/requirements.txt
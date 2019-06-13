FROM ubuntu:16.04
MAINTAINER kenneth.daily@sagebionetworks.org
ENV VERSION=1.0
ENV NAME=fastq-split-readgroup-tool
RUN apt-get update
COPY bin/split-read-group /usr/local/bin/
ENV PATH /usr/local/bin:$PATH
CMD ["split-read-group"]

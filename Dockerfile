FROM ubuntu:22.04
WORKDIR /Taskwarrior-installation
COPY . .
RUN apt-get update && apt-get -y install apt-utils && apt-get -y install sudo && apt-get install -y git
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone
RUN chmod +x tw-install.sh && ./tw-install.sh
ARG TASKDDATA
ENV TASKDDATA ${TASKDDATA:-/var/taskd}
ENTRYPOINT taskd server --data ${TASKDDATA}
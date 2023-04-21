FROM registry.access.redhat.com/ubi8

ENV NOVNC_TAG="v1.4.0"
ENV WEBSOCKIFY_TAG="v0.11.0"

WORKDIR /app/noVNC

RUN yum install -y \
      hostname git procps-ng python3 python3-pip && \
      yum -y clean all && \
      rm -rf /var/cache

RUN pip3 install --upgrade --no-cache-dir numpy && \  
    git clone --depth 1 --branch ${NOVNC_TAG} https://github.com/novnc/noVNC.git /app/noVNC && \
	git clone --depth 1 --branch ${WEBSOCKIFY_TAG} https://github.com/kanaka/websockify /app/noVNC/utils/websockify && \
    ln -s vnc.html index.html && \
    chmod 775 -R /app && \
    chgrp 0 -R /app

COPY entrypoint.sh /app

USER 1001

EXPOSE 8080

LABEL maintainer="Cory Latschkowski <clatsch@redhat.com>" \
      org.opencontainers.image.description.vendor="Cory Latschkowski" \
      org.opencontainers.image.description="A noVNC container - connect to vnc in your browser" \
      org.opencontainers.image.source="https://github.com/codekow/container-novnc"

ENTRYPOINT ["/app/entrypoint.sh"]

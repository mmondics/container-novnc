FROM registry.access.redhat.com/ubi8

ENV NOVNC_TAG="v1.4.0"
ENV WEBSOCKIFY_TAG="v0.11.0"

WORKDIR /app/noVNC

RUN yum install -y \
      hostname git procps-ng python3 python3-pip python3-devel gcc gcc-c++ gcc-gfortran make && \
    yum -y clean all && \
    rm -rf /var/cache

# Download and install OpenBLAS
RUN curl -L https://github.com/xianyi/OpenBLAS/archive/v0.3.13.tar.gz -o OpenBLAS-0.3.13.tar.gz && \
    tar zxvf OpenBLAS-0.3.13.tar.gz && \
    cd OpenBLAS-0.3.13 && \
    make && \
    make install && \
    cd .. && \
    rm -rf OpenBLAS-0.3.13 OpenBLAS-0.3.13.tar.gz

# Ensure Cython is installed correctly
RUN pip3 install --upgrade --no-cache-dir Cython==0.29.24

# Install numpy separately
RUN pip3 install --upgrade --no-cache-dir numpy==1.19.5

RUN git clone --depth 1 --branch ${NOVNC_TAG} https://github.com/novnc/noVNC.git /app/noVNC && \
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

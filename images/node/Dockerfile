ARG VERSION=20
FROM --platform=$TARGETPLATFORM node:${VERSION}-bookworm-slim

LABEL author="HostNatPro" maintainer="contact@hostnatpro.com"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git \
       curl \
       jq \
       file \
       unzip \
       make \
       gcc \
       g++ \
       python3 \
       python3-dev \
       python3-pip \
       libtool \
       ca-certificates \
       iproute2 \
       dnsutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@latest

RUN useradd -m -d /home/container -s /bin/bash container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]

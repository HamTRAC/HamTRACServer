FROM ubuntu AS develop
LABEL org.opencontainers.image.source https://github.com/HamTRAC/HamTRACServer

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    ca-certificates \
    build-essential \
    cmake \
    ninja-build \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# download and install rapidjson
RUN wget -c https://github.com/Tencent/rapidjson/archive/refs/heads/master.tar.gz -O - | tar -xz \
    && cd rapidjson-master \
    && cmake -GNinja -Bbuild -H. \
    && cmake --build build/ --target install \
    && cmake --build build/ --target clean \
    && ldconfig

WORKDIR /root/HamTRACServer



FROM develop AS builder

COPY ./ ./
RUN cmake -GNinja -Bbuild -H. \
    && cmake --build build/ --target HamTRACServer



FROM ubuntu AS production

WORKDIR /root

COPY --from=develop /usr/local/lib /usr/local/lib
RUN ldconfig
COPY --from=builder /root/HamTRACServer/build/src/HamTRACServer ./
CMD [ "./HamTRACServer" ]

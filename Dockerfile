FROM ubuntu
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
    git \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# download, compile and install Paho MQTT C
RUN git clone https://github.com/eclipse/paho.mqtt.c.git \
    && cd paho.mqtt.c \
    && git checkout v1.3.8 \
    && cmake -GNinja -Bbuild -H. -DPAHO_ENABLE_TESTING=OFF -DPAHO_BUILD_STATIC=ON -DPAHO_HIGH_PERFORMANCE=ON \
    && cmake --build build/ --target install \
    && cmake --build build/ --target clean \
    && ldconfig \
    && cd ..

# download, compile and install Paho MQTT CPP
RUN git clone https://github.com/eclipse/paho.mqtt.cpp \
    && cd paho.mqtt.cpp \
    && git checkout v1.2.0 \
    && cmake -GNinja -Bbuild -H. -DPAHO_BUILD_STATIC=ON -DPAHO_BUILD_DOCUMENTATION=FALSE -DPAHO_BUILD_SAMPLES=TRUE -DPAHO_WITH_SSL=OFF \
    && cmake --build build/ --target install \
    && cmake --build build/ --target clean \
    && ldconfig \
    && cd ..

# download and install Protobuf
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protoc-3.17.3-linux-x86_64.zip \
    && mkdir protoc \
    && cd protoc \
    && unzip ../protoc-3.17.3-linux-x86_64.zip \
    && cp bin/* /usr/local/bin/ \
    && cp -R include/* /usr/local/include/ \
    && cd ..

# download and install rapidjson
RUN git clone https://github.com/Tencent/rapidjson.git \
    && cd rapidjson \
    && cmake -GNinja -Bbuild -H. \
    && cmake --build build/ --target install \
    && cmake --build build/ --target clean \
    && ldconfig \
    && cd ..

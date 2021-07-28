FROM ubuntu
LABEL org.opencontainers.image.source https://github.com/HamTRAC/HamTRACServer

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    ca-certificates \
    build-essential \
    gcc \
    make \
    cmake \
    git \
    unzip \
    wget\
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/eclipse/paho.mqtt.c.git \
    && cd paho.mqtt.c \
    && git checkout v1.3.8 \
    && cmake -Bbuild -H. -DPAHO_ENABLE_TESTING=OFF -DPAHO_BUILD_STATIC=ON -DPAHO_HIGH_PERFORMANCE=ON \
    && cmake --build build/ --target install \
    && cmake --build build/ --target clean \
    && ldconfig \
    && cd ..

RUN git clone https://github.com/eclipse/paho.mqtt.cpp \
    && cd paho.mqtt.cpp \
    && git checkout v1.2.0 \
    && cmake -Bbuild -H. -DPAHO_BUILD_STATIC=ON -DPAHO_BUILD_DOCUMENTATION=FALSE -DPAHO_BUILD_SAMPLES=TRUE -DPAHO_WITH_SSL=OFF \
    && cmake --build build/ --target install \
    && cmake --build build/ --target clean \
    && ldconfig \
    && cd ..

RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protoc-3.17.3-linux-x86_64.zip \
    && mkdir protoc \
    && cd protoc \
    && unzip ../protoc-3.17.3-linux-x86_64.zip \
    && cp bin/* /usr/local/bin/ \
    && cp -R include/* /usr/local/include/ \
    && cd ..

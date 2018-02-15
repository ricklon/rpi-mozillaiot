#FROM resin/rpi-raspbian:latest AS base 

FROM node:carbon 

RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils wget unzip build-essential cmake pkg-config \
  libusb-1.0-0-dev libudev-dev \
  git vim

WORKDIR /usr/local/iot

# Install open-zwave
RUN git clone https://github.com/OpenZWave/open-zwave.git
WORKDIR /usr/local/iot/open-zwave
RUN make && make install
RUN ldconfig

ENV  LD_LIBRARY_PATH=/usr/local/lib/:RUNLD_LIBRARY_PATH

# INstall Mozilla IOT gateway
RUN git clone https://github.com/mozilla-iot/gateway.git

WORKDIR /usr/local/iot/gateway

RUN mkdir -p ssl
RUN openssl genrsa -out ssl/privatekey.pem 2048
RUN openssl req -new -sha256 -key ssl/privatekey.pem -out ssl/csr.pem \
  -subj "/C=US/ST=New-Jersey/L=HiglandPark/O=mozzlon/OU=HomeThings/CN=rickanderson.world"
RUN openssl x509 -req -in ssl/csr.pem -signkey ssl/privatekey.pem -out ssl/certificate.pem

# use the lts version of node

WORKDIR /usr/local/iot/gateway
RUN yarn
RUN npm start

RUN npm test






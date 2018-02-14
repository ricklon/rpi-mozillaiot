FROM resin/rpi-raspbian:latest 

RUN apt-get update && apt-get install -y --no-install-recommends \
  wget unzip build-essential cmake pkg-config \
  libusb-1.0-0-dev libudev-dev \
  git vim

WORKDIR /usr/local/iot

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

RUN nvm install --lts
RUN nvm use --lts
RUN nvm alias default lts/*

RUN git clone https://github.com/OpenZWave/open-zwave.git
RUN cd open-zwave
RUN make && sudo make install
RUN ldconfig

ENV  LD_LIBRARY_PATH=/usr/local/lib/:RUNLD_LIBRARY_PATH


RUN cd
RUN git clone https://github.com/mozilla-iot/gateway.git


WORKDIR /usr/local/iot/gateway

RUN yarn

RUN mkdir -p ssl
RUN openssl genrsa -out ssl/privatekey.pem 2048
RUN openssl req -new -sha256 -key ssl/privatekey.pem -out ssl/csr.pem
RUN openssl x509 -req -in ssl/csr.pem -signkey ssl/privatekey.pem -out ssl/certificate.pem

RUN npm start

RUN npm test






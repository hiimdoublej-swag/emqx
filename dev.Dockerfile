FROM erlang:23.2-slim AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    zip \
    unzip \
    vim \
    build-essential \
    debhelper \
    libssl-dev \
    automake \
    autoconf \
    libncurses5-dev \
    gcc \
    g++ \
    make \
    cmake \
    zlib1g-dev \
    libffi-dev \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    jq \
    unixodbc \
    unixodbc-dev


RUN wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz \
    && tar xvf Python-3.7.4.tgz \
    && cd Python-3.7.4 \
    && echo "_socket socketmodule.c" >> Modules/Setup.dist \
    && echo "_ssl _ssl.c -DUSE_SSL -I/usr/local/ssl/include -I/usr/local/ssl/include/openssl -L/usr/local/ssl/lib -lssl -lcrypto" >> Modules/Setup.dist \
    && ./configure --prefix=/usr/local/python3.7.4 \
    && make \
    && make install \
    && rm -rf /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/local/python3.7.4/bin/python3.7 /usr/bin/python3 \
    && ln -s /usr/local/python3.7.4/bin/python3.7 /usr/bin/python
RUN sed -i 's/python3/python2.7/1' /usr/bin/lsb_release \
    && curl -k -L -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py \
    && python /tmp/get-pip.py \
    && python3 /tmp/get-pip.py
ENV PATH=/usr/local/python3.7.4/bin:$PATH

# cleanup
RUN apt-get clean\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /workdir

COPY ./ ./

# Use dev plugins

RUN mv ./lib-extra/plugins.dev ./lib-extra/plugins
ENV EMQX_EXTRA_PLUGINS=emqx_reloader

RUN make

# emqx will occupy these port:
# - 1883 port for MQTT
# - 8081 for mgmt API
# - 8083 for WebSocket/HTTP
# - 8084 for WSS/HTTPS
# - 8883 port for MQTT(SSL)
# - 11883 port for internal MQTT/TCP
# - 18083 for dashboard
# - 4369 for port mapping (epmd)
# - 4370 for port mapping
# - 5369 for gen_rpc port mapping
# - 6369 for distributed node
EXPOSE 1883 8081 8083 8084 8883 11883 18083 4369 4370 5369 6369
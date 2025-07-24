FROM alpine
ARG major_minor_version
ARG mysql_version

WORKDIR /mysql-build
RUN apk add bash boost-dev cmake curl g++ gcc libaio libaio-dev libc-dev libedit-dev linux-headers make perl pwgen openssl openssl-dev bison libtirpc libtirpc-dev git rpcgen

SHELL ["/bin/bash", "-c"]
RUN echo $(echo $(if [[ $current_version == "8.0.43" || $current_version == "8.4.6" || $current_version == "9.4.0" ]]; then echo "https://cdn.mysql.com/Downloads/MySQL-"; else echo "https://cdn.mysql.com/archives/mysql-"; fi)$(echo $major_minor_version)/mysql-$(echo $mysql_version).tar.gz)
RUN echo "URL is going to be $(echo $URL)"
RUN curl -fSL $(echo $URL) -o mysql.tar.gz
RUN tar -xzf mysql.tar.gz

RUN \
    cd mysql-$(echo $mysql_version) \
    && mkdir mysql \
    && cd mysql \
    && cmake .. -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/tmp -DDOWNLOAD_BOOST_TIMEOUT=2000 -DWITH_ROUTER=OFF -DWITH_MYSQLX=OFF \
    && make -j$(nproc) \
    && echo 'Complete' \
    && ls
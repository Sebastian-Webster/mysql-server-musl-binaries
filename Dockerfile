FROM alpine
ARG major_minor_version
ARG mysql_version
ARG url
ARG release_type

WORKDIR /mysql-build
RUN apk add boost-dev cmake curl g++ gcc libaio libaio-dev libc-dev libedit-dev linux-headers make perl pwgen openssl openssl-dev bison libtirpc libtirpc-dev git rpcgen
RUN curl -fSL $(echo $url) -o mysql.tar.gz
RUN tar -xzf mysql.tar.gz

RUN \
    cd mysql-$(echo $mysql_version)$(echo $release_type) \
    && mkdir mysql \
    && cd mysql \
    && cmake .. -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/tmp -DDOWNLOAD_BOOST_TIMEOUT=2000 -DWITH_ROUTER=OFF -DWITH_MYSQLX=OFF -DWITH_UNIT_TESTS=OFF -DWITH_BUILD_ID=OFF \
    && make -j$(nproc) \
    && echo 'Complete' \
    && ls
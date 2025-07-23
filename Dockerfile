FROM alpine
RUN apk add boost-dev cmake curl g++ gcc libaio libaio-dev libc-dev libedit-dev linux-headers make perl pwgen openssl openssl-dev bison
RUN \
    curl -fSL http://cdn.mysql.com/Downloads/MySQL-9.4/mysql-9.4.0.tar.gz -o mysql.tar.gz \
    && mkdir -p /usr/src \
    && tar -xzC /usr/src -f mysql.tar.gz

RUN \
    cd /usr/src/mysql-9.4.0 \
    mkdir bld \
    cd bld \
    && cmake .. -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/tmp -DDOWNLOAD_BOOST_TIMEOUT=2000 -DWITH_ROUTER=OFF -DWITH_MYSQLX=OFF \
    && make -j$(nproc) \
    && echo 'Complete' \
    && ls
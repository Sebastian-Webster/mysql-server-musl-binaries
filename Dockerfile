FROM alpine
ARG major_minor_version
ARG mysql_version
ARG current_version

WORKDIR /mysql-build
RUN apk add boost-dev cmake curl g++ gcc libaio libaio-dev libc-dev libedit-dev linux-headers make perl pwgen openssl openssl-dev bison libtirpc libtirpc-dev git rpcgen
RUN echo $( if [ $current_version -eq 1 ]; then echo "https://cdn.mysql.com/Downloads/MySQL-"; else echo "https://cdn.mysql.com/archives/mysql-"; fi )$(echo $major_minor_version)/mysql-$(echo $mysql_version).tar.gz
RUN \
    curl -fSL $( if [ $current_version -eq 1 ]; then echo "https://cdn.mysql.com/Downloads/MySQL-"; else echo "https://cdn.mysql.com/archives/mysql-"; fi )$(echo $major_minor_version)/mysql-$(echo $mysql_version).tar.gz -o mysql.tar.gz \
    && tar -xzf mysql.tar.gz

RUN \
    cd mysql-$(echo $mysql_version) \
    && mkdir mysql \
    && cd mysql \
    && cmake .. -DBUILD_CONFIG=mysql_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/tmp -DDOWNLOAD_BOOST_TIMEOUT=2000 -DWITH_ROUTER=OFF -DWITH_MYSQLX=OFF \
    && make -j$(nproc) \
    && echo 'Complete' \
    && ls
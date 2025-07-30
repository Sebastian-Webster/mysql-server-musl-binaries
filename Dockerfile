FROM alpine
ARG mysql_version
ARG url

WORKDIR /mysql-build
RUN apk add boost-dev cmake curl g++ gcc libaio libaio-dev libc-dev libedit-dev linux-headers make perl pwgen openssl openssl-dev bison libtirpc libtirpc-dev git rpcgen

RUN curl -fSL $(echo $url) -o mysql.tar.gz
RUN tar -xzf mysql.tar.gz

RUN \
    cd mysql-$(echo $mysql_version) \
    && mkdir mysql-$(echo $mysql_version) \
    && cd mysql-$(echo $mysql_version) \
    && cmake .. -DBUILD_CONFIG=mysql_release -DWITH_ROUTER=OFF -DWITH_UNIT_TESTS=OFF -DWITH_BUILD_ID=OFF -DWITH_CLIENT_PROTOCOL_TRACING=OFF -DWITH_RAPID=OFF -DCMAKE_BUILD_RPATH='$ORIGIN/../lib' \
    && make -j$(nproc) \
    && echo "Complete" \
    && ls

RUN mv mysql-$(echo $mysql_version) mysql-source

CMD ["./mysql-source/runtime_output_directory/mysqld", "--version"]
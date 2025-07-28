FROM alpine
ARG major_minor_version
ARG mysql_version
ARG url
ARG release_type
ARG boost_version
ARG boost_version_u
ARG legacy_openssl
ENV mysql_bin_folder="/mysql-version/mysql/runtime_output_directory"

WORKDIR /mysql-build
RUN apk add boost-dev cmake curl doxygen g++ gcc libaio libaio-dev libc-dev libedit-dev linux-headers make perl pwgen openssl-dev bison libtirpc libtirpc-dev git rpcgen

RUN if [ "$legacy_openssl" == "true" ]; then echo "Downloading and building legacy OpenSSL" && git clone https://github.com/openssl/openssl && cd openssl && git checkout OpenSSL_1_1_1v && ./config && make -j$(nproc) && make install && echo "Installed legacy OpenSSL successfully"; else apk add openssl; fi

RUN if [ -n "$boost_version" ] && [ -n "$boost_version_u" ]; then echo "Downloading boost $boost_version..." && curl -O https://archives.boost.io/release/$(echo $boost_version)/source/boost_$(echo $boost_version_u).tar.gz && tar -xvf boost_$(echo $boost_version_u).tar.gz -C /tmp; else echo "Boost downloaded not specified. Skipping..."; fi

RUN \
    cp -r /usr/include/tirpc/rpc /usr/include/rpc \
    && cp /usr/include/tirpc/netconfig.h /usr/include \
    && echo "RPC folder:" \
    && ls /usr/include/rpc

RUN curl -fSL $(echo $url) -o mysql.tar.gz
RUN tar -xzf mysql.tar.gz

RUN \
    cd mysql-$(echo $mysql_version)$(echo $release_type) \
    && mkdir mysql \
    && cd mysql \
    && cmake .. -DBUILD_CONFIG=mysql_release -DWITH_BOOST=/tmp/boost_$(echo $boost_version_u) -DWITH_ROUTER=OFF -DWITH_MYSQLX=OFF -DWITH_UNIT_TESTS=OFF -DWITH_BUILD_ID=OFF -DWITH_CLIENT_PROTOCOL_TRACING=OFF -DWITH_RAPID=OFF \
    && make -j$(nproc) \
    && echo "Complete" \
    && ls

RUN mv mysql-$(echo $mysql_version)$(echo $release_type) mysql-source

CMD ["./mysql-source/runtime_output_directory/mysqld", "--version"]
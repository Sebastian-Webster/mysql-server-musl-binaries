## MySQL Server musl libc binaries

This repository has a Dockerfile and a GitHub Actions workflow file in it. The Dockerfile is used to download the MySQL Server source code and then compile it in Alpine Linux. The workflow file is to compile MySQL server and to upload the resultant binaries to this repository's release page. You can find the binaries at this repository's releases page. This repository is the source for [mysql-memory-server](https://github.com/Sebastian-Webster/mysql-memory-server-nodejs)'s MySQL Server binaries for people who run the package on Alpine Linux.

## Limitations

1. MySQL Router is not available in the build as there are errors when compiling with musl
2. The MySQL X Plugin is not available in the build as there are errors when compiling with musl
3. Builds for MySQL versions 8.0.29, 8.0.38, 8.4.1, and 9.0.0 are not available as MySQL removed these versions from their CDN due to critical issues
4. MySQL v5.x & v8.0.0 - v8.0.1 & v8.0.11 - v8.0.35, and v8.0.41 - 8.3.0 builds are not available due to errors when compiling with musl

## Compile MySQL yourself

If you are running Alpine Linux or any other musl libc based Linux distribution, execute the commands that are in the Dockerfile (replacing the environment variables with actual values instead of env variables). For everyone else, make sure you have Docker installed. Clone the repository and then in the repository's root directory run the following command:

```docker build -t mysql-musl .```

Depending on the speed of your hardware and how much resources you allocate to Docker, this can take from a few minutes to many hours. Once the Docker image has been built, you'd need to extract the MySQL binaries from the image. You can run the following command to do that:

```docker export $(docker create mysql-musl) -o mysql-musl.tar```

Untar the file however you like, but here is an example way to do that:

```tar -xvf mysql-musl.tar```

The output folder will be the file contents from a container created from the Docker image's contents. The mysql-build/mysql-VERSION/runtime_output_directory folder will have all the binaries produced from the calculation (replace VERSION with the MySQL version that was compiled).

## Disclaimer

Oracle does not officially support MySQL compiling with musl libc. There are some versions of MySQL that will just not compile with musl libc because of problems with the MySQL code that come from the lack of support for musl from Oracle. There may be limitations and issues with the binaries provided in this repository. Contributions are welcomed for this repository to improve support and get more MySQL versions building on musl libc. However, this repository will only accept contributions that make edits to the build process, meaning this repository will not accept any fixes to the code of MySQL to get certain versions of MySQL compiling for musl libc. The compiled binaries must come from the original source code released from Oracle.

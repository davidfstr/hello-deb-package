FROM debian:latest

# Install build dependencies
RUN apt-get update
RUN apt-get install build-essential -y  # install gcc

# Download source code
COPY ./hello.c /usr/src/

# Compile the binary (AKA: make)
RUN gcc -o /tmp/hello /usr/src/hello.c

# Install the binary (AKA: make install)
RUN cp /tmp/hello /usr/bin/hello

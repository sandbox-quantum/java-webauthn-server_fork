FROM alpine:3

ARG liboqs_sha=5dd87dcaafa6f90e983ef464f9f6a75f9485fb26
ARG liboqs_java_sha=9088d7abc1176dab8936430fd7463dc824292165

# EXPOSE 8443

RUN \
    apk update && \
    # Install JDK and Git
    # Currently compatible only with v17
    apk add openjdk17 git cmake ninja clang openssl-dev linux-headers maven
RUN \
    # Clone liboqs
    mkdir /liboqs && \
    cd /liboqs && \
    git init && \
    git remote add origin https://github.com/open-quantum-safe/liboqs.git && \
    git fetch --depth 1 origin $liboqs_sha && \
    git checkout FETCH_HEAD && \
    # Build liboqs
    mkdir build && \
    cd build && \
    cmake -GNinja -DBUILD_SHARED_LIBS=ON .. && \
    ninja && \
    ninja install
RUN \
    # Clone liboqs-java
    mkdir /liboqs-java && \
    cd /liboqs-java && \
    git init && \
    git remote add origin https://github.com/sandbox-quantum/liboqs-java_fork.git && \
    git fetch --depth 1 origin $liboqs_java_sha && \
    git checkout FETCH_HEAD && \
    # Build liboqs-java
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk mvn package -Dliboqs.include.dir="/usr/local/include" -Dliboqs.lib.dir="/usr/local/lib"

# Copy the source code for the server
COPY . /java-webauthn-server
RUN \
    # Build java-webauthn-server
    cd /java-webauthn-server && \
    ./gradlew :webauthn-server-core:jar && \
    chmod +x ./docker-run.sh

WORKDIR /java-webauthn-server/
CMD ["./docker-run.sh"]

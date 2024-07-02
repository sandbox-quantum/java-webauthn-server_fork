FROM python:3.11

RUN \
    apt update && \
    apt install curl git -y && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    python3 -m pip install --user mercurial && \
    curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O
    
RUN \
    hg --config format.generaldelta=true init ./mozilla-unified
    
COPY hgrc /mozilla-unified/.hg/

RUN \
    cd mozilla-unified && \
    hg pull && \
    hg update 752936 --clean

COPY firefox.diff /

# RUN \
#     cargo install cbindgen && \
#     apt install clang nodejs llvm -y

RUN \
    cd mozilla-unified && \
    hg up -C central

# RUN \
#     cd mozilla-unified && \
#     patch -p1 < /firefox.diff

RUN \
    cd mozilla-unified && \
    ./mach --no-interactive bootstrap --application-choice browser


# RUN \
#     cd mozilla-unified && \
#     cargo update -p authrs_bridge

# RUN \
#     cd mozilla-unified && \
#     CC=$HOME/.mozbuild/clang/bin/clang ./mach configure

# RUN \
#     cd mozilla-unified && \
#     ./mach build

# RUN \
#     cd mozilla-unified && \
#     hg pull && 

# RUN \
#     hg clone https://hg.mozilla.org/mozilla-unified && \
#     cd mozilla-unified && \
#     hg update 752936 --clean

# RUN \
#     python3 bootstrap.py --no-interactive --application-choice="browser"

CMD ["/bin/bash"]

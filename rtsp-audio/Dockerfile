FROM --platform=linux/386 i386/ubuntu:18.04@sha256:fc896f56642f382e99601461c683dee1534f0d4cb7e17bcb3494d5ed0f3a8a06
RUN apt-get update -qq && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*
ARG SDK_REF=a336655804af5395383e44d8cbfb9085e73c88d9
RUN mkdir -p /opt/gm /build/gm_lib/inc /build/gm_lib/lib && \
    curl -fL "https://raw.githubusercontent.com/xurubin/gm8136_rtspd/${SDK_REF}/sdk/toolchain_gnueabi-4.4.0_ARMv5TE.tgz" -o /tmp/toolchain.tgz && \
    echo "751ba19db68246628767cf0c8d4f0017eac00261a55e0cc6b39514fe80987dfc  /tmp/toolchain.tgz" | sha256sum -c - && \
    tar xzf /tmp/toolchain.tgz -C /opt/gm && rm /tmp/toolchain.tgz && \
    for file in gm_lib/inc/gmlib.h gm_lib/lib/libgm.so librtsp.h librtsp.a; do \
      curl -fL "https://raw.githubusercontent.com/xurubin/gm8136_rtspd/${SDK_REF}/${file}" -o "/build/${file}" || exit 1; \
    done
ENV PATH="/opt/gm/toolchain_gnueabi-4.4.0_ARMv5TE/usr/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/gm/toolchain_gnueabi-4.4.0_ARMv5TE/usr/lib"
WORKDIR /build
COPY rtspd.c /build/rtspd.c
RUN arm-unknown-linux-uclibcgnueabi-gcc -std=gnu99 -Wall -Igm_lib/inc -Lgm_lib/lib -o rtsp_audio rtspd.c librtsp.a -lgm -lpthread -lm -lrt
CMD ["/bin/true"]

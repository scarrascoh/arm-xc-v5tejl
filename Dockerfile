FROM scarrascoh/arm-xc:1.23.0

LABEL maintainer="scarrascoh.develop@gmail.com" \
      version=1.23.0 \
      description="ARM cross-compile Docker image for v5tejl" 

RUN mkdir armv5tejl && \
    chown -R arm:arm $WORKDIR

USER arm

ADD config/.config $WORKDIR/armv5tejl
COPY config/tarballs/* $WORKDIR/src/

RUN cd armv5tejl && \
    ct-ng oldconfig && \
    ct-ng build && \
    cd .. && \
    rm -r crosstool-ng-${XTOOLNG_VERSION}

ENV PATH="${PATH}:$WORKDIR/x-tools/armv5tejl-unknown-linux-gnueabi/bin"

CMD ["bash"]

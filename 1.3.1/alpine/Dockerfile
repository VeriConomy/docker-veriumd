FROM alpine

#Will need to change to appropriate URL when its on vericonomy
#RUN wget http://statics.derasse.ovh/verium-1.3.0/verium-1.3.0-x86_64-linux-gnu.tar.gz

ARG VERSION=1.3.1
ARG GLIBC_VERSION=2.29-r0

ENV FILENAME verium-${VERSION}-x86_64-linux-gnu.tar.gz
#ENV DOWNLOAD_URL http://statics.derasse.ovh/verium-${VERSION}/${FILENAME}
ENV DOWNLOAD_URL https://files.vericonomy.com/vrm/${FILENAME}

# Some of this was unabashadly yanked from
# https://github.com/szyhf/DIDockerfiles/blob/master/bitcoin/alpine/Dockerfile
# and https://github.com/jamesob/docker-bitcoind/blob/master/Dockerfile

#Update package database
#Install applicable packages for use
#Download verium binary
#move appropriate files to /usr/local/bin
#cleanup the temporary files

RUN apk update \
  && apk --no-cache add wget tar bash ca-certificates \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
  && wget $DOWNLOAD_URL \
  && tar xzvf /verium-${VERSION}-x86_64-linux-gnu.tar.gz \
  && mkdir /root/.verium \
  && mv /verium-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /verium-${VERSION}/ \
  && rm -rf /verium-${VERSION}-x86_64-linux-gnu.tar.gz \
  && apk del tar wget ca-certificates

EXPOSE 33987 36988

COPY docker_entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]

FROM ubuntu:20.04

ARG VERSION=1.3.2
ARG CHECKSUM=SHA512SUMS

ENV FILENAME verium-${VERSION}-x86_64-linux-gnu.tar.gz
ENV DOWNLOAD_URL https://files.vericonomy.com/vrm/releases/${VERSION}/${FILENAME}
ENV DOWNLOAD_CHECKSUM https://files.vericonomy.com/vrm/releases/${VERSION}/${CHECKSUM}

# Some of this was unabashadly yanked from
# https://github.com/szyhf/DIDockerfiles/blob/master/bitcoin/alpine/Dockerfile
# and https://github.com/jamesob/docker-bitcoind/blob/master/Dockerfile

#Update Ubuntu
#Download verium binary
#move appropriate files to /usr/local/bin
#cleanup the temporary files

RUN apt-get update \
  && apt-get install -y \
  wget \
  && wget $DOWNLOAD_URL \
  && wget $DOWNLOAD_CHECKSUM \
  && tar xzvf /verium-${VERSION}-x86_64-linux-gnu.tar.gz \
  && sha512sum --check --ignore-missing SHA512SUMS \
  && mkdir /root/.verium \
  && mv /verium-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /verium-${VERSION}/ \
  && rm -rf /verium-${VERSION}-x86_64-linux-gnu.tar.gz

EXPOSE 33987 33988

COPY docker_entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]

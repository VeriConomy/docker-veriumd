FROM ubuntu:20.04

#RUN wget http://statics.derasse.ovh/verium-1.3.0/verium-1.3.0-x86_64-linux-gnu.tar.gz
# https://plik.root.gg/file/K1PvjRTGiTqKMoVZ/awVENsqeRRgwYR9k/verium-1.3.0-x86_64-linux-gnu.tar.gz

ARG VERSION=1.3.0

ENV FILENAME verium-${VERSION}-x86_64-linux-gnu.tar.gz
ENV DOWNLOAD_URL https://plik.root.gg/file/K1PvjRTGiTqKMoVZ/awVENsqeRRgwYR9k/verium-${VERSION}/${FILENAME}

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
#  libminizip-dev \
  && wget $DOWNLOAD_URL \
  && tar xzvf /verium-${VERSION}-x86_64-linux-gnu.tar.gz \
  && mkdir /root/.verium \
  && mv /verium-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /verium-${VERSION}/ \
  && rm -rf /verium-${VERSION}-x86_64-linux-gnu.tar.gz

EXPOSE 33987 36988

ADD VERSION .
ADD ./bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]

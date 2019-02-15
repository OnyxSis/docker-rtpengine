#jessie
FROM debian:9
MAINTAINER Ian Blenke <ian@blenke.com>

ENV DEB_BUILD_PROFILES="pkg.ngcp-rtpengine.nobcg729"

ADD https://github.com/sipwise/rtpengine/archive/mr7.1.1.1.tar.gz /
RUN tar -xvf mr7.1.1.1.tar.gz
RUN mv rtpengine-mr7.1.1.1 /rtpengine
WORKDIR /rtpengine

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qqy && \
    apt-get install -qqy dpkg-dev debhelper iptables-dev libcurl4-openssl-dev libglib2.0-dev libhiredis-dev libpcre3-dev libssl-dev libxmlrpc-core-c3-dev markdown zlib1g-dev module-assistant dkms gettext libevent-dev libbencode-perl libcrypt-rijndael-perl libdigest-hmac-perl libio-socket-inet6-perl libsocket6-perl netcat-openbsd netcat libpcap0.8-dev default-libmysqlclient-dev gperf libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libcrypt-openssl-rsa-perl libdigest-crc-perl libio-multiplex-perl libjson-glib-dev libnet-interface-perl libswresample-dev libsystemd-dev nfs-common && \
    dpkg-checkbuilddeps && \
    dpkg-buildpackage -b -us -uc && \
    dpkg -i /*.deb && \
    ( ( apt-get install -y linux-headers-$(uname -r) linux-image-$(uname -r) && \
        module-assistant update && \
        module-assistant auto-install ngcp-rtpengine-kernel-source ) || true )

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD /run.sh


#jessie
FROM debian:8
MAINTAINER Ian Blenke <ian@blenke.com>

ADD https://github.com/sipwise/rtpengine/archive/mr4.5.11.2.tar.gz /
RUN tar -xvf mr4.5.11.2.tar.gz
RUN mv rtpengine-mr4.5.11.2 /rtpengine
WORKDIR /rtpengine

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qqy && \
    touch ./debian/flavors/no_ngcp && \
    apt-get install -qqy dpkg-dev debhelper iptables-dev libcurl4-openssl-dev libglib2.0-dev libhiredis-dev libpcre3-dev libssl-dev libxmlrpc-core-c3-dev markdown zlib1g-dev module-assistant dkms gettext libevent-dev libbencode-perl libcrypt-rijndael-perl libdigest-hmac-perl libio-socket-inet6-perl libsocket6-perl netcat-openbsd netcat libpcap0.8-dev && \
    dpkg-checkbuilddeps && \
    dpkg-buildpackage -b -us -uc && \
    dpkg -i /*.deb && \
    ( ( apt-get install -y linux-headers-$(uname -r) linux-image-$(uname -r) && \
        module-assistant update && \
        module-assistant auto-install ngcp-rtpengine-kernel-source ) || true )

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD /run.sh


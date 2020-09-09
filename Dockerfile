FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV container docker
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update &&\
 DEBIAN_FRONTEND=noninteractive\
 apt-get install -y fuse snapd snap-confine squashfuse sudo build-essential ubuntu-image git &&\
 apt-get clean &&\
 dpkg-divert --local --rename --add /sbin/udevadm &&\
 ln -s /bin/true /sbin/udevadm 

RUN systemctl enable snapd

VOLUME ["/sys/fs/cgroup"]

STOPSIGNAL SIGRTMIN+3

#RUN useradd -ms /bin/bash -u 1000 builder 
#RUN useradd -m -N -s /bin/bash -u 1000 -p '$1$HMjfTD9w$7Fv/HmXJhSat..0MLBAxF/' builder && 
#    usermod -aG sudo builder && 

# set trivial root-password + auto-login (passwd gen: openssl passwd -1 "123456")
RUN	usermod -p '$1$HMjfTD9w$7Fv/HmXJhSat..0MLBAxF/' root && \
		sed -i -e 's/--noclear %I/--noclear -a root %I/g' /usr/lib/systemd/system/getty@.service

#RUN snap install snapcraft --classic

#USER builder

CMD ["/sbin/init"]


#VOLUME heads
#
##RUN git clone https://github.com/osresearch/heads ~/heads
#
#RUN cd /heads && \
#    echo "master" && \
#    git pull && \
#	make

#RUN make BOARD=x220


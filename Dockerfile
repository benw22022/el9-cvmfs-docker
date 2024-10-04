# FROM gitlab-registry.cern.ch/sft/docker/alma9-core:latest
FROM quay.io/centos/centos:stream9

# metainformation
LABEL org.opencontainers.image.version = "1.1.0"
LABEL org.opencontainers.image.authors = "Zihan Zhang, Ben Wilson"
LABEL org.opencontainers.image.source = "https://zhangzi.web.cern.ch"
# LABEL org.opencontainers.image.base.name="gitlab-registry.cern.ch/sft/docker/alma9-core:latest"

RUN yum update -y && yum groupinstall "Development Tools" -y \
 && yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel freetype-devel libXt-devel libX11-devel expat-devel motif\
    readline-devel tk-devel libpcap-devel xz-devel libXpm-devel \
    libXext-devel wget which ghostscript

RUN yum install -y epel-release gcc-gfortran pcre-devel \
    mesa-libGL-devel mesa-libGLU-devel fftw-devel libuuid-devel \
    openldap-devel libxml2-devel readline-devel \
    openssl java sudo

RUN yum install -y qt5-qtbase qt5-qtbase-gui qt5-qtx11extras libxcb libxcb-devel

RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
 && yum install -y cvmfs

COPY my_cvmfs_repository.conf /etc/cvmfs/default.local

RUN mkdir -p /cvmfs/atlas.cern.ch \
 && mkdir -p /cvmfs/atlas-condb.cern.ch \
 && mkdir -p /cvmfs/atlas-nightlies.cern.ch \
 && mkdir -p /cvmfs/grid.cern.ch \
 && mkdir -p /cvmfs/sft-nightlies.cern.ch \
 && mkdir -p /cvmfs/sft.cern.ch \
 && mkdir -p /cvmfs/unpacked.cern.ch \
 && mkdir -p /cvmfs/geant4.cern.ch \
 && cvmfs_config setup

RUN sed -i 's%#+dir:/etc/auto.master.d%+dir:/etc/auto.master.d%' /etc/auto.master

CMD ["service", "autofs", "start"]

# Install Python=3.10
RUN cd /tmp \
 && wget https://www.python.org/ftp/python/3.9.17/Python-3.9.17.tgz \
 && tar -zxf Python-3.9.17.tgz && cd Python-3.9.17 \
 && ./configure --enable-optimizations && make altinstall \
 && ln -fs /usr/local/bin/python3.9 /usr/bin/python3 \
 && ln -fs /usr/local/bin/pip3.9 /usr/bin/pip3 \
 && ln -fs /usr/local/bin/python3.9 /usr/bin/python \
 && ln -fs /usr/local/bin/pip3.9 /usr/bin/pip

RUN ln -fs /usr/bin/python2.7 /usr/bin/python \
 && ln -fs /usr/bin/pip2.7 /usr/bin/pip \
 && pip3 install six

RUN rm -rf /tmp/*

RUN useradd atreus \
 && usermod -aG wheel atreus \
 && echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" | tee -a /etc/sudoers 

USER atreus

ENV HOME=/home/atreus
RUN chmod 777 /home/atreus \
 && ln -fs /mnt /home/atreus/data

WORKDIR /home/atreus

RUN echo "sudo mount -t cvmfs atlas.cern.ch /cvmfs/atlas.cern.ch" | tee -a /home/atreus/.bashrc \
 && echo "sudo mount -t cvmfs atlas-condb.cern.ch /cvmfs/atlas-condb.cern.ch" | tee -a /home/atreus/.bashrc \
 && echo "sudo mount -t cvmfs atlas-nightlies.cern.ch /cvmfs/atlas-nightlies.cern.ch" | tee -a /home/atreus/.bashrc \
 && echo "sudo mount -t cvmfs grid.cern.ch /cvmfs/grid.cern.ch" | tee -a /home/atreus/.bashrc \
 && echo "sudo mount -t cvmfs sft-nightlies.cern.ch /cvmfs/sft-nightlies.cern.ch" | tee -a /home/atreus/.bashrc \
 && echo "sudo mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch" | tee -a /home/atreus/.bashrc \
 && echo "sudo mount -t cvmfs unpacked.cern.ch /cvmfs/unpacked.cern.ch" | tee -a /home/atreus/.bashrc \
 && echo "sudo mount -t cvmfs geant4.cern.ch /cvmfs/geant4.cern.ch" | tee -a /home/atreus/.bashrc

RUN echo "export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase" | tee -a /home/atreus/.bashrc \
 && echo "alias setupATLAS='source \${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'" | tee -a /home/atreus/.bashrc

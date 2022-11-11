FROM jupyter/scipy-notebook
LABEL maintainer="Keren Zhu <keren.zhu@utexas.edu>"

# Switch to root user
USER root 


# Install cmake 3.16.3
ADD https://cmake.org/files/v3.16/cmake-3.16.3-Linux-x86_64.sh /cmake-3.16.3-Linux-x86_64.sh
RUN mkdir /opt/cmake \
        && sh /cmake-3.16.3-Linux-x86_64.sh --prefix=/opt/cmake --skip-license \
        && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
        && cmake --version

# Update apt packages
RUN apt update
RUN apt upgrade -y

# Install boost flex
RUN apt-get install -y \
    build-essential zlib1g-dev libncurses5-dev libnss3-dev libssl-dev \
    libreadline-dev libffi-dev \
    libboost-all-dev flex csh vim \
    python3-openssl 
    
# Update openssl
RUN apt-get remove -y openssl
RUN wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz --no-check-certificate \
        && tar -zxf openssl-1.1.1d.tar.gz && cd openssl-1.1.1d \
        && ./config && make && make install \
        && ln -s /usr/local/bin/openssl /usr/bin/openssl && ldconfig \
        && openssl version
        

# Install lp_solve
RUN git clone https://github.com/krzhu/lp_solve.git  \
        && cd lp_solve/lpsolve55 \
        && sh ccc \
        && cp ~/lp_solve/lpsolve55/bin/ux64/* ~/lp_solve
ENV LPSOLVE_DIR=/home/jovyan/lp_solve

# Install lemon
RUN wget lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz --no-check-certificate
RUN tar -xf lemon-1.3.1.tar.gz \
        && mkdir lemon-1.3.1/build && cd lemon-1.3.1/build \ 
        && cmake -DCMAKE_INSTALL_PREFIX=~/lemon .. \
        && make && make install 
ENV LEMON_DIR=/home/jovyan/lemon


# Install eigen
RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.3/eigen-3.3.3.tar.gz --no-check-certificate \
        && tar -xf eigen-3.3.3.tar.gz 
ENV EIGEN_INC=/home/jovyan/eigen-3.3.3

# Install pybind11
RUN git clone https://github.com/pybind/pybind11.git
ENV PYBIND11_DIR=/home/jovyan/pybind11

#  python lib
RUN apt-get install python3-dev
RUN apt-get install -y python2-dev python2 python-dev-is-python3

# Install sparsehash
RUN wget https://github.com/sparsehash/sparsehash/archive/refs/tags/sparsehash-2.0.4.tar.gz --no-check-certificate
RUN tar -xf sparsehash-2.0.4.tar.gz \
        && cd sparsehash-sparsehash-2.0.4 \
        && ./configure --prefix=/sparsehash \
        && make && make install
ENV SPARSE_HASH_DIR=/sparsehash

# Install bison 3.4
RUN wget http://ftp.gnu.org/gnu/bison/bison-3.4.tar.gz --no-check-certificate
RUN tar -xf bison-3.4.tar.gz \
        && cd bison-3.4 \
        && ./configure && make && make install \
        && ln -s /usr/local/bin/bison /usr/bin/bison \
        && bison --version

# Install limbo
RUN git clone https://github.com/limbo018/Limbo.git
RUN perl -pi -e 's/TRUE/FTRUE/g' Limbo/limbo/solvers/api/LPSolveApi.h # Work around the legacy issue of lpsolve
RUN mkdir Limbo/build && cd Limbo/build \
        && cmake .. -DCMAKE_INSTALL_PREFIX=/limbo \
        && make && make install
ENV LIMBO_DIR=/limbo
ENV LIMBO_INC=/limbo/include

# Install python prerequisite
RUN pip install networkx matplotlib scipy numpy Cython pybind11
RUN git clone https://github.com/jayl940712/gdspy.git \
        && pip install gdspy/

# Install Boost
RUN apt-get install libboost-all-dev

# Install magical
RUN mkdir install && cd install && git clone https://github.com/magical-eda/MAGICAL.git \
        && cd MAGICAL && git checkout docker \
        && git submodule init && git submodule update \
.       && cd anaroute && git checkout cicc2021 \
        && cd /home/jovyan/install/MAGICAL/device_generation && git checkout sky130 \
        && cd /home/jovyan/install/MAGICAL\
        && git checkout skywater \
        && ./build.sh

#
# Dockerfile for Unminimized Linux and other tools
# Base image: Official Ubuntu-based Jupyter foundation stack
#

FROM quay.io/jupyter/base-notebook:latest

LABEL description="Unminimized Linux Ubuntu environment with limited VS Code support."

USER root

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV SHELL=/bin/bash

# Set up jovyan similar to existing image
# Modify existing user/group or || create them if they do not exist
RUN groupmod -g 1000 ${NB_USER} || groupadd -g 1000 ${NB_USER} && \
    usermod -u 1000 -g ${NB_USER} ${NB_USER} || useradd -u 1000 -g ${NB_USER} -m -s /bin/bash ${NB_USER}
    
# Create an ${NB_USER} sudo configuration file using '>'
RUN echo "${NB_USER} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/${NB_USER}_sudo && \
    chmod 0440 /etc/sudoers.d/${NB_USER}_sudo

# Get apt packages and unminimize Ubuntu
RUN apt-get update -y && apt-get -qq install -y --no-install-recommends \
    unminimize \
    coreutils \ 
    && (yes || true) |  unminimize \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Refer to README.md for additional packages installed, apt skips if already installed
RUN apt-get -qq update -y && apt-get -qq install -y --no-install-recommends \
    bash \
    findutils \ 
    grep \
    sed \
    gawk \
    diffutils \
    patch \
    less \
    nano \
    vim \
    emacs \
    aspell \
    file \
    landscape-common \
    man-db \
    manpages \
    manpages-dev \
    info \
    groff \ 
    tar \
    gzip \
    bzip2 \
    xz-utils \ 
    zip \
    unzip \
    cpio \
    sudo \
    passwd \
    libpam-modules \ 
    pamtester \
    acl \
    attr \
    procps \
    psmisc \
    htop \
    atop \
    iotop \
    lsof \
    strace \
    ltrace \
    sysstat \
    pciutils \
    usbutils \
    lsscsi \
    sg3-utils \
    hdparm \
    udev \
    parted \
    fdisk \
    gdisk \
    e2fsprogs \ 
    dosfstools \ 
    xfsprogs \
    btrfs-progs \ 
    squashfs-tools \ 
    lvm2 \
    mdadm \
    systemd \
    systemd-sysv \
    cron \
    logrotate \
    rsyslog \
    iproute2 \
    net-tools \
    iputils-ping \
    traceroute \
    dnsutils \
    tcpdump \
    netcat-openbsd \ 
    nmap \
    openssh-client \
    openssh-server \
    sshfs \
    cifs-utils \
    nfs-common \
    rsync \
    curl \
    wget \
    build-essential \ 
    gcc \
    g++ \
    make \
    autoconf \
    automake \
    pkg-config \
    cmake \
    git \
    flex \
    bison \
    gdb \
    valgrind \
    clangd \
    texlive-xetex \ 
    texlive-fonts-recommended \ 
    texlive-plain-generic \
    pandoc \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    
# Install code-server (VS Code in browser)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Rebuild manual page database index for man/apropos commands
RUN mandb -c || true

USER ${NB_USER}
WORKDIR /home/${NB_USER}

# Set default user environment variables in bashrc
RUN echo '# Course Environment Customizations' >> ~/.bashrc \
    && echo 'export PATH="${HOME}/bin:${PATH}"' >> ~/.bashrc \
    && echo 'export EDITOR="vim"' >> ~/.bashrc \
    && echo 'export VISUAL="vim"' >> ~/.bashrc \
    && echo 'export PAGER="less"' >> ~/.bashrc \
    && echo 'alias ls="ls --color=auto"' >> ~/.bashrc \
    && echo 'alias ll="ls -alF"' >> ~/.bashrc

# install C++ kernel xeus (bloated, clean up kernels)
RUN mamba install -c conda-forge xeus-cpp jupyterlab -y

# keep xc17
RUN rm -rf /opt/conda/share/jupyter/kernels/xc11 \
    && rm -rf /opt/conda/share/jupyter/kernels/xc23 \
    && rm -rf /opt/conda/share/jupyter/kernels/xc23-omp

# keep xcpp20
RUN rm -rf /opt/conda/share/jupyter/kernels/xcpp11 \
    && rm -rf /opt/conda/share/jupyter/kernels/xcpp14 \
    && rm -rf /opt/conda/share/jupyter/kernels/xcpp17 \
    && rm -rf /opt/conda/share/jupyter/kernels/xcpp23 \
    && rm -rf /opt/conda/share/jupyter/kernels/xcpp23-omp
        
# Install jupyter-vscode-proxy in the conda environment to integrate VS Code into JupyterLab Launcher
RUN pip install --no-cache-dir jupyter-server-proxy jupyter-vscode-proxy \
    && code-server --install-extension ms-python.python \
    && code-server --install-extension ms-vscode.cmake-tools \
    && code-server --install-extension llvm-vs-code-extensions.vscode-clangd
    
# RUN bash conda deactivate
ENV CONDA_AUTO_ACTIVATE_BASE=false
RUN rm -rf work

EXPOSE 8888
CMD ["jupyter","lab",--ip=0.0.0.0", "--no-browser"}

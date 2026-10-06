# SMC base image with extra Linux utilities

Jupyter lab image with Ubuntu Linux unminimized. Also includes vs-code. Inherits from quay.io/jupyter/base-notebook:latest.

## Additional Packages
### Shells & Core Command Utilities:
- bash, findutils, grep, sed, gawk, diffutils, patch, less, nano
- vim, emacs, aspell, file, landscape-sysinfo (alternative to sysinfo)
### Manuals & Documentation:
- man-db, manpages-dev, info, groff
### Archiving & Compression:
- tar, gzip, bzip2, xz-utils, zip, unzip, cpio
### User Administration, PAM & Security:
- sudo, passwd, libpam-modules, pamtester, acl, attr, shadow (not installed)
### Process Control & Diagnostics:
- procps, psmisc, htop, atop, iotop, lsof, strace, ltrace, sysstat
### Hardware, Bus & Device Inspection:
- pciutils, usbutils, lsscsi, sg3-utils, hdparm, udev
### Disks, Filesystems, LVM & RAID:
- parted,fdisk, gdisk, e2fsprogs, dosfstools, xfsprogs, btrfs-progs
- squashfs-tools, lvm2, mdadm
### Booting, Init, Services & Logging:
- systemd, systemd-sysv, cron, logrotate, rsyslog 
### Networking & Remote Management:
- iproute2, net-tools, iputils-ping, traceroute, dnsutils, tcpdump, netcat-openbsd, nmap 
- openssh-client, openssh-server, sshfs, cifs-utils, nfs-common, rsync, curl, wget 
### Software Compilation & C/C++ Development:
- build-essential, gcc, g++, make, autoconf, automake, pkg-config 
- cmake, git, flex, bison, gdb, valgrind, clangd 
### Export as pdf support:
- texlive-xetex, texlive-fonts-recommended, texlive-plain-generic, pandoc

If Dockerfile exists in the repo, repo2docker will ignore the apt.txt and postBuild configuration files. 

Refer to the cal-icor/base-user-image repository's [CONTRIBUTING.md](https://github.com/cal-icor/base-user-image/blob/main/CONTRIBUTING.md) for further instructions on creating a custom image. 

## Building the image locally

You should use [repo2docker](https://repo2docker.readthedocs.io/en/latest/) to build and use/test the image on your own device before you push and create a PR.  It's better (and typically faster) to do this first before using CI/CD.  There's no need to waste Github Action minutes to test build images when you can do this on your own device!

Run `repo2docker` from inside the cloned image repo.  To run on a linux/WSL2 linux shell:

```
repo2docker . # <--- the path to the repo
```

If you are using an ARM CPU (Apple M* silicon), you will need to run `jupyter-repo2docker` with the following arguments:

```
jupyter-repo2docker --user-id=1000 --user-name=jovyan \
  --Repo2Docker.platform=linux/amd64 \
  --target-repo-dir=/home/jovyan/.cache \
  -e PLAYWRIGHT_BROWSERS_PATH=/srv/conda \
  . # <--- the path to the repo
```

If you just want to see if the image builds, but not automatically launch the server, add `--no-run` to the arguments (before the final `.`).

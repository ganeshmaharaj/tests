#!/bin/bash
#
# Copyright (c) 2019 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

cidir=$(dirname "$0")
source "/etc/os-release" || source "/usr/lib/os-release"
source "${cidir}/lib.sh"

echo "Install chronic"
sudo -E zypper -n install moreutils

echo "Install curl"
chronic sudo -E zypper -n install curl

echo "Install git"
chronic sudo -E zypper -n install git

echo "Install kata containers dependencies"
chronic sudo -E zypper -n install libtool automake autoconf bc perl-Alien-SDL libpixman-1-0-devel coreutils

echo "Install qemu dependencies"
chronic sudo -E zypper -n install libcap-devel libattr1 libcap-ng-devel librbd-devel

echo "Install kernel dependencies"
chronic sudo -E zypper -n install libelf-devel flex

echo "Install CRI-O dependencies"
chronic sudo -E zypper -n install libglib-2_0-0 libseccomp-devel libapparmor-devel libgpg-error-devel python2-pkgconfig \
	go-md2man glibc-devel-static thin-provisioning-tools libgpgme-devel libassuan-devel glib2-devel glibc-devel \
	libcontainers-common libostree-devel libdevmapper1_03 util-linux

echo "Install bison binary"
chronic sudo -E zypper -n install bison

echo "Install libudev-dev"
chronic sudo -E zypper -n install libudev-devel

echo "Install Build Tools"
chronic sudo -E zypper -n install patterns-devel-base-devel_basis python pkg-config zlib-devel

echo "Install tools for metrics tests"
chronic sudo -E zypper -n install smemstat jq

if [ "$(arch)" == "x86_64" ]; then
	echo "Install Kata Containers OBS repository"
	obs_url="${KATA_OBS_REPO_BASE}/openSUSE_Leap_${VERSION_ID}"
	chronic sudo -E zypper addrepo --no-gpgcheck "${obs_url}/home:katacontainers:releases:$(arch):master.repo"
fi

echo -e "Install cri-containerd dependencies"
chronic sudo -E zypper -n install libseccomp-devel libapparmor-devel make pkg-config

echo "Install crudini"
chronic sudo -E zypper -n install crudini

echo "Install haveged"
chronic sudo -E zypper -n install haveged

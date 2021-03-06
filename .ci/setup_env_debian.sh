#!/bin/bash
#
# Copyright (c) 2018 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

cidir=$(dirname "$0")
source "/etc/os-release" || source "/usr/lib/os-release"
source "${cidir}/lib.sh"
export DEBIAN_FRONTEND=noninteractive

echo "Install chronic"
sudo -E apt install -y moreutils

echo "Install curl"
sudo -E apt install -y curl

echo "Install git"
sudo -E apt install -y git

echo "Install kata containers dependencies"
chronic sudo -E apt install -y libtool automake autotools-dev autoconf bc alien libpixman-1-dev coreutils parted

echo "Install qemu dependencies"
chronic sudo -E apt install -y libcap-dev libattr1-dev libcap-ng-dev librbd-dev

echo "Install kernel dependencies"
chronic sudo -E apt install -y libelf-dev flex

echo "Install CRI-O dependencies for Debian"
chronic sudo -E apt install -y libglib2.0-dev libseccomp-dev libapparmor-dev \
        libgpgme11-dev go-md2man thin-provisioning-tools

echo "Install bison binary"
chronic sudo -E apt install -y bison

echo "Install libudev-dev"
chronic sudo -E apt-get install -y libudev-dev

echo "Install Build Tools"
chronic sudo -E apt install -y build-essential python pkg-config zlib1g-dev

echo -e "Install CRI-O dependencies available for Debian"
chronic sudo -E apt install -y libdevmapper-dev btrfs-tools util-linux

chronic sudo -E apt install -y libostree-dev

echo "Install YAML validator"
chronic sudo -E apt install -y yamllint

echo "Install tools for metrics tests"
chronic sudo -E apt install -y smem jq

echo "Enable librbd1 repository"
sudo bash -c "cat <<EOF > /etc/apt/sources.list.d/unstable.list
deb http://deb.debian.org/debian unstable main contrib non-free
deb-src http://deb.debian.org/debian unstable main contrib non-free
EOF"

echo "Lower priority than stable"
sudo bash -c "cat <<EOF > /etc/apt/preferences.d/unstable
Package: *
Pin: release a=unstable
Pin-Priority: 10
EOF"

echo "Install librbd1"
chronic sudo -E apt update && sudo -E apt install -y -t unstable librbd1

if [ "$(arch)" == "x86_64" ]; then
	echo "Install Kata Containers OBS repository"
	obs_url="${KATA_OBS_REPO_BASE}/Debian_${VERSION_ID}"
	sudo sh -c "echo 'deb $obs_url /' > /etc/apt/sources.list.d/kata-containers.list"
	curl -sL  "${obs_url}/Release.key" | sudo apt-key add -
	chronic sudo -E apt-get update
fi

echo -e "Install cri-containerd dependencies"
chronic sudo -E apt install -y libseccomp-dev libapparmor-dev btrfs-tools  make gcc pkg-config

echo "Install crudini"
chronic sudo -E apt install -y crudini

echo "Install procenv"
chronic sudo -E apt install -y procenv

echo "Install haveged"
chronic sudo -E apt install -y haveged

if [ "$KATA_KSM_THROTTLER" == "yes" ]; then
	echo "Install ${KATA_KSM_THROTTLER_JOB}"
	chronic sudo -E apt install -y ${KATA_KSM_THROTTLER_JOB}
fi

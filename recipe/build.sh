#!/usr/bin/env bash

set -xe

mkdir -p ${PREFIX}/bin ${BUILD_PREFIX}/bin/

# `make config` checks against a static list of supported compilers
# make `x86_64-conda-linux-gnu-gfortran` available as `gfortran`

if [[ "${target_platform}" == "osx-arm64" ]]; then
    ln -s ${FC_FOR_BUILD} ${BUILD_PREFIX}/bin/gfortran
    ln -s ${CC_FOR_BUILD} ${BUILD_PREFIX}/bin/gcc
else
    ln -s ${FC} ${BUILD_PREFIX}/bin/gfortran
    ln -s ${CC} ${BUILD_PREFIX}/bin/gcc
fi

FC=gfortran NETCDFROOT=${PREFIX} make config

FFLAGS="${FFLAGS} -fno-second-underscore -fallow-argument-mismatch" \
    FFLAGS90="${FFLAGS} -fno-second-underscore -fallow-argument-mismatch -ffree-line-length-none" \
    make mpi

install -m 0755 swan.exe ${PREFIX}/bin
install -m 0755 swanrun ${PREFIX}/bin

unlink ${BUILD_PREFIX}/bin/gfortran
unlink ${BUILD_PREFIX}/bin/gcc

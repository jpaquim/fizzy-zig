#!/usr/bin/env bash

set -ex

DIR=$PWD/fizzy
JOBS=8
pushd $DIR
  cmake .
  make -j $JOBS
popd

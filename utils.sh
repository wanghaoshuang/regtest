#!/bin/bash
#
# Define some common functions.
#
# Copyright (c) 2016 PaddlePaddle Authors. All Rights Reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

# error code
readonly E_ARGS_NUM=1
readonly E_DIR_NO_EXIST=2

# some constants
readonly MODELS_URL='https://github.com/PaddlePaddle/models.git'
readonly PADDLE_URL='https://github.com/PaddlePaddle/Paddle.git'

function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

#################################################
# Pull latest src from remote github repo
# Globals:
#   None
# Arguments:
#   url: git repo url
#   path: local repo path
# Returns:
#   commit id
################################################
function pull_repo() {
  [[ $# -ne 2 ]] && err "Arguments error!" && return ${E_ARGS_NUM};
  local path=$2
  local url=$1
  if [ -d $path ]; then
    if [ ! -d ${path}/.git ]; then
        err "$path exists, but it is not a git repo."
        return ${E_DIR_NO_EXIST}
    fi
    cd ${path}
    remote=`git remote | grep "upstream" || true`
    if [[ 'S' == 'S'$remote ]];then
        git remote add upstream $url
    fi
    git fetch upstream
    git pull upstream develop
    cd -
  else
    git clone $url $path
  fi

  cd ${path}
    echo `git rev-parse HEAD`
  cd -
}

######################################
# Build and install paddle
# Globals:
#   None
# Arguments:
#   path: local paddle source path
#   thread_num: optional, number of thread for building and installing
# Returns:
#   None
######################################
function build_install() {
  [[ $# > 2 || $# < 1 ]] && err "Arguments error!" && return ${E_ARGS_NUM};
  local path=$1
  local thread_num=16
  [[ $# == 2 ]] && thread_num=$2
  [ ! -d ${path}/build ] && \
    err """please ensure ${path}/build exists,
    and being builded success manually before calling build_install""" && \
    return ${E_DIR_NO_EXIST}

  cd ${path}/build
  cmake ..
  make -j${thread_num} && make install -j${thread_num}
  if [ ! -d ${path}/output ];then
    echo "please ensure building output path is ${path}/output"
  fi
  cd -
  pip uninstall -y ${path}/output/opt/paddle/share/wheels/*.whl
  pip install ${path}/output/opt/paddle/share/wheels/*.whl
}

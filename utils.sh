#!/bin/bash
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

# some constants
models_url='https://github.com/PaddlePaddle/models.git'
paddle_url='https://github.com/PaddlePaddle/Paddle.git'


# pull latest src from remote github repo
# usage:
#   pull_repo url path
# arguments:
#   url: git repo url
#   path: local repo path
pull_repo() {
  [[ $# -ne 2 ]] && echo "arguments error!" && return 1;
  path=$2
  url=$1
  if [ -d $path ]; then
    if [ ! -d ${path}/.git ]; then
        echo "$path exists, but it is not a git repo."
        exit 1
    fi
    cd ${path}
    remote=`git remote | grep "upstream"`
    if [[ '' == $remote ]];then
        git remote add upstream $url
    fi
    git fetch upstream
    git pull upstream develop
    cd -
  else
    git clone $url $path
  fi
}

# Build and install paddle
# usage:
#   build_install path
# arguments:
#   path: local paddle source path
build_install() {
  path=$1
  [ ! -d ${path}/build ] && \
    echo """please ensure ${path}/build exists,
    and being builded success manually before calling build_install""" && \
    return 1
  [ -d ${path}/output ] && rm -rf ${path}/output
  cd ${path}/build
  cmake ..
  make -j32 && make install -j32
  if [ ! -d ${path}/output ];then
    echo "please ensure building output path is ${path}/output"
  fi
  cd -
  pip uninstall -y ${path}/output/opt/paddle/share/wheels/*.whl
  pip install ${path}/output/opt/paddle/share/wheels/*.whl
}

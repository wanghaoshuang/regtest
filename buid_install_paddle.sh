#!/bin/bash
#
# Pull latest paddle src, build and install.
# This script should be used in a paddle develop docker image.
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
. ./utils.sh
readonly USAGE="---------------------
  USAGE:
    ./${0} <options>
  Arguments:
    <options>: Options while building paddle. Such as:
               'WITH_GPU=OFF WITH_AVX=ON WITH_TESTING=OFF
               RUN_TEST=OFF PYTHON_ABI=cp27-cp27mu'
------------------"


readonly MIN_ARGS_SIZE=1
readonly MODELS_URL='https://github.com/PaddlePaddle/models.git'
readonly PADDLE_URL='https://github.com/PaddlePaddle/Paddle.git'
readonly PADDLE_PATH='/paddle'
[[ ${MIN_ARGS_SIZE} < $# ]] && err "${USAGE}" && exit ${E_ARGS_NUM}
options="${@}"
[[ -d ${PADDLE_PATH} ]] && rm -rf ${PADDLE_PATH}
git clone ${PADDLE_URL} ${PADDLE_PATH}

cd /
env ${options} \
bash ${PADDLE_PATH}/paddle/scripts/docker/build.sh
pip uninstall ${PADDLE_PATH}/build/python/dist/*.whl
pip install ${PADDLE_PATH}/build/python/dist/*.whl
cd -

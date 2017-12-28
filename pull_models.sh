#!/bin/bash
#
# Pull latest models from git repo.
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

readonly USAGE="---------------------
  USAGE:
    ./${0} <models_path>
  Arguments:
    <models_path>: Local absolution path of models.
------------------"
set -ex
. ./utils.sh
readonly MODELS_URL='https://github.com/PaddlePaddle/models.git'
readonly ARGS_SIZE=1
models_path=$1
[[ ${ARGS_SIZE} -ne $# ]] && err "${USAGE}" && exit ${E_ARGS_NUM}

[[ -d ${models_path} ]] && rm -rf ${models_path}
git clone ${MODELS_URL} ${models_path}

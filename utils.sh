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
set -ex
# error code
readonly E_ARG_NUM=1
readonly E_FILE_NOT_FOUND=2

function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

###############################
# Run a model according to configs
# Globals:
#   None
# Arguments:
#   model_path: Absolution path of a model which should
#               contains a  entry script 'train.py'
#   config_file: A config file with several options groups.
#                Each line of config_file is a group of options
#                with style as bellow:
#                "--use_gpu=False --learning_rate=0.1"
#                It will run the model once  for each line
#                in config_file.
#   log_path: The absolution path of log files. It will generate a log file
#             for each line in config_file with name as 'config_${config_id}.log'
# Return:
#   None
###############################
function run_model() {
  [[ $# -ne 3 ]] && err "Arguments error!" && return ${E_ARG_NUM}
  local model_path=$1
  local config_file=$2
  local log_path=$3
  [[ -d ${log_path} ]] && rm -rf ${log_path}
  mkdir -p ${log_path}
  [[ ! -f ${config_file} ]] && err "${config_file} doesn't exists!" \
  return ${E_FILE_NOT_FOUND}
  local line_num=0
  cd ${model_path}
  cat ${config_file} | while read option; do
    python train.py ${option} &> ${log_path}/config_${line_num}.log
    let line_num+=1
    # TODO(wanghaoshuang): Retry after failed
  done
  cd -
  return 0
}

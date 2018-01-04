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
. ./utils.sh
export PATH=`pwd`:$PATH
export PYTHONPATH=`pwd`:$PYTHONPATH

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
  local TIME_BIN='/usr/bin/time'
  local REPORT_NAME='report'
  # TODO(wanghaoshuang): Add more metrics
  local TIME_FORMAT="""metric:elapsed_real_time=%e
metric:mrss=%M"""
  local num_args=3
  [[ $# -ne ${num_args} ]] && err "Arguments error!" && return ${E_ARG_NUM}
  local model_path=$1
  local config_file=$2
  local log_path=$3
  [[ ! -d ${log_path} ]] && mkdir -p ${log_path}
  [[ ! -f ${config_file} ]] && err "${config_file} doesn't exists!" \
  return ${E_FILE_NOT_FOUND}
  local line_num=0
  cd ${model_path}
  [[ -f ${log_path}/${REPORT_NAME} ]] && rm ${log_path}/${REPORT_NAME}
  # TODO(wanghaoshuang): Support for multiline
  cat ${config_file} | while read option; do
    # train
    ${TIME_BIN} -f "${TIME_FORMAT}" python train.py ${option} &> ${log_path}/config_${line_num}.log

    cd ${log_path}
    # analysis log
    cat ./config_${line_num}.log | analysis.py &> ./config_${line_num}.result
    # generate report
    render.py --baseline_file="config_${line_num}.baseline" \
    --result_file="config_${line_num}.result" \
    --template_file="report.html" >> ${REPORT_NAME}
    cd ${log_path}

    let line_num+=1
    # TODO(wanghaoshuang): Retry after failed
  done
  cd -
  return 0
}

run_model "${@}"

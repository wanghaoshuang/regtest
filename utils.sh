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


function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

###############################
# Run a model according to configs
# Globals:
#   None
# Arguments:
#   model_path:
#   config_file:
#   log_path:
# return:
#   None
###############################
function run_model() {
  [[ $# < 1 || $# > 3 ]] && echo "args err"; return 1
  model_path=$1
  log_path=${model_path}/log/
  rm -rf ${log_path}
  mkdir -p ${log_path}
  if [ -d ${model_path}/baseline ];then
      cd ${model_path}
      for config in `${model_path}/baseline/case*`
      do
        python ${model_path}/train.py `head -1 ${model_path}/baseline/$config` >> ${log_path}/${config}.log
      done
      cd -
  fi

}
